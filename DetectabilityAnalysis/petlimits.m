clear; close all; clc;
N = 256;                 % image size
FOV_mm = 160;            % field of view
dx = FOV_mm / N;         % mm/pixel

lesion_diameters_mm = [2 3 4 5 6 8 10];  % sweep (edit as you like)
C_true = 4.0;            % true lesion-to-background ratio (within prostate)
A_bg = 0.6;              % body background uptake
A_pro = 0.8;             % prostate baseline uptake

psf_sigma_px = 2.5;      % PET blur sigma (pixels). Key knob.
do_noise = true;         
counts_scale = 2e4;      % higher -> less noisy
nMC = 50;                

% lesion center (mm) within prostate
les_center_mm = [0, 12]; % x,y

% prostate center (mm) and size
prostate_center_mm = [0, 20];
prostate_axes_mm = [18, 13];  % semi-axes (a,b) in mm

% body/pelvis ellipse size
pelvis_axes_mm = [70, 55];

[xp, yp] = meshgrid((1:N)-N/2, (1:N)-N/2);
x_mm = xp * dx;
y_mm = yp * dx;

pelvis = ((x_mm/pelvis_axes_mm(1)).^2 + (y_mm/pelvis_axes_mm(2)).^2) <= 1;

xpr = x_mm - prostate_center_mm(1);
ypr = y_mm - prostate_center_mm(2);
prostate = ((xpr/prostate_axes_mm(1)).^2 + (ypr/prostate_axes_mm(2)).^2) <= 1;

CRC_mean  = zeros(size(lesion_diameters_mm));
CRC_std   = zeros(size(lesion_diameters_mm));
Chat_mean = zeros(size(lesion_diameters_mm));
Chat_std  = zeros(size(lesion_diameters_mm));

for i = 1:numel(lesion_diameters_mm)

    d = lesion_diameters_mm(i);
    r = d/2;

    lesion = ((x_mm - les_center_mm(1)).^2 + (y_mm - les_center_mm(2)).^2) <= r^2;
    lesion = lesion & prostate;

    bgmask = prostate & ~lesion;

    PET_true = zeros(N);
    PET_true(pelvis)   = A_bg;
    PET_true(prostate) = A_pro;
    PET_true(lesion)   = A_pro * C_true;

    % --- PET system blur (resolution / PSF) ---
    PET_blur = imgaussfilt(PET_true, psf_sigma_px);

    if ~do_noise

        mu_les = mean(PET_blur(lesion));
        mu_bg  = mean(PET_blur(bgmask));
        C_hat  = mu_les / mu_bg;
        CRC    = (C_hat - 1) / (C_true - 1);

        CRC_mean(i)  = CRC;
        CRC_std(i)   = 0;
        Chat_mean(i) = C_hat;
        Chat_std(i)  = 0;

    else
  
        CRCs  = zeros(nMC,1);
        Chats = zeros(nMC,1);

        for k = 1:nMC
            counts = poissrnd(PET_blur * counts_scale);
            PET_meas = counts / counts_scale;

            mu_les = mean(PET_meas(lesion));
            mu_bg  = mean(PET_meas(bgmask));
            C_hat  = mu_les / mu_bg;

            Chats(k) = C_hat;
            CRCs(k)  = (C_hat - 1) / (C_true - 1);
        end

        CRC_mean(i)  = mean(CRCs);
        CRC_std(i)   = std(CRCs);
        Chat_mean(i) = mean(Chats);
        Chat_std(i)  = std(Chats);
    end
end

FWHM_px = 2*sqrt(2*log(2)) * psf_sigma_px;
FWHM_mm = FWHM_px * dx;

fprintf('PET PSF sigma = %.2f px (%.2f mm)\n', psf_sigma_px, psf_sigma_px*dx);
fprintf('Approx PET FWHM = %.2f px (%.2f mm)\n', FWHM_px, FWHM_mm);

fig = figure('Color','w','Position',[100 100 1150 450]);

subplot(1,2,1);
errorbar(lesion_diameters_mm, CRC_mean, CRC_std, 'o-','LineWidth',1.5);
grid on;
xlabel('Lesion diameter (mm)');
ylabel('Contrast Recovery Coefficient (CRC)');
title(sprintf('CRC vs Lesion Size (FWHM \\approx %.1f mm)', FWHM_mm));
ylim([0 1.1]);

subplot(1,2,2);
errorbar(lesion_diameters_mm, Chat_mean, Chat_std, 'o-','LineWidth',1.5);
grid on;
xlabel('Lesion diameter (mm)');
ylabel('Observed lesion-to-background ratio \hat{C}');
title(sprintf('Observed Contrast vs Size (C_{true}=%.1f)', C_true));

exportgraphics(fig,'track2_crc_results.png','Resolution',300);

save('track2_crc_results.mat', ...
    'lesion_diameters_mm','C_true','A_bg','A_pro','psf_sigma_px','dx','FWHM_mm', ...
    'do_noise','counts_scale','nMC', ...
    'CRC_mean','CRC_std','Chat_mean','Chat_std');

disp('Saved track2_crc_results.png and track2_crc_results.mat');