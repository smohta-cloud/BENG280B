Prostate cancer is one of the most prevalent forms of cancer among males globally. In 2020, it resulted in the death of over 1.4 million people. Despite the fact that localized prostate cancer is treatable, the early detection of small or low-volume lesions is difficult. The use of image-based techniques is vital in the diagnosis, staging, and treatment of prostate cancer. However, each technique is limited by physical constraints. Each technique is limited by spatial resolution, the image's ability to show an object's location. 
A PET/MRI scanner captures MRI, which provides high-resolution anatomy, and PET, which shows functional tracer uptake. Since Prostate Specific Membrane Antigen (PSMA) is significantly overexpressed on the membranes of prostate cancer cells, PSMA PET tracers show improved detection compared to other PET tracers, such as choline and fluorodeoxyglucose-18 (F-18). 
Recent studies show high sensitivity for clinically significant prostate cancer and improved localization of lesions with PET-MRI combinations. However, the limits of detectability are largely determined by PET physics and include spatial resolution, attenuation, scatter, and statistical noise. These limitations directly affect the detectability of lesions, particularly small lesions. PET/MRI combinations are further complicated by attenuation correction and quantification limitations associated with combined-modality PET/MRI systems used to image patients with prostate cancer. 

In our PET/MRI study, we used MRI for anatomical context to localize prostate lesions and define a realistic lesion size range, employing regions of interest (ROIs), while PET is modeled to detect the smallest lesion size, given its limited spatial resolution (blur) and noise. 

Project Goals: 
The goal of this project was to quantitatively determine the detectability limits of PET/MRI for detecting small prostate lesions under controlled conditions. 
Analysis I: Simulate PET lesion detection certainty over MRI Scans  
Analysis II: Quantitatively evaluate PET contrast recovery as a function of lesion size
Analysis III: Quantify PSMA tracer uptake for PET/MRI imaging and analyze the interplay of parameters like FWHM, LBR, and noise ratio in lesion detectability.

Analysis I Simulations:
Quantifying the limits of small lesion detection is a fundamental goal in PET imaging physics. Traditional image-quality measures such as contrast recovery and noise do not directly translate to clinical performance because they fail to capture the observer’s ability to separate signal from noise in a detection task. ROC analysis is widely recognized as a robust performance metric in lesion detection studies, specifically measuring sensitivity vs. specificity across decision thresholds 

Published phantom and clinical PET detectability studies demonstrate a wide range of minimum detectable lesion sizes depending on contrast levels and imaging conditions. Human observer studies using physical phantoms with standardized spheres show that modern clinical PET/CT scanners can image spheres as small as ~5 mm at high contrast (~15:1), but at typical clinical contrasts (~2:1), the smallest reliably detectable lesions are substantially larger [10]. Thus, a formal detectability criterion (e.g., AUC ≥ 0.8) is required to define a lesion size–contrast combination as practically detectable in PET. This study uses rigorous simulation to evaluate whether and how such criteria can be met in prostate PET imaging scenarios.

Analysis I Methods:
Anatomical Constraint and Simulated PET Images

An axial T2-weighted MRI slice of a prostate was manually segmented to define the true gland region. This MRI-defined mask ensured that synthetic PET lesions were placed only where clinically plausible, imposing realistic anatomical constraints on the simulation.

A uniform baseline PET uptake was assigned to the prostate region, and circular lesions were inserted with diameters ranging from 1 mm to 12 mm and contrast ratios from 2:1 to 10:1 relative to background. Lesions were randomly placed within the mask for each realization.

Imaging Physics Simulation: The PET point spread function was approximated by a Gaussian kernel to model partial volume effects typical of clinical systems. Poisson-distributed noise was added to simulate count-limited acquisitions. Multiple noisy realizations were generated for each parameter set to facilitate statistical evaluation of detectability.

Detectability Criterion and ROC/AUC Metrics: Detectability was quantified per size–contrast condition using ROC analysis. The area under the ROC curve (AUC) was computed from simulated signal-present and signal-absent images. A higher AUC indicates better separation of lesion and background signals; setting a criterion (e.g., AUC ≥ 0.8) defines a practical performance threshold above random chance and below perfect detection. ROC analysis is an accepted method for evaluating PET lesion detection because it accounts for both sensitivity and specificity across observer thresholds

Logistic Regression Modeling: A logistic regression model was fitted to approximate the probability of meeting the detectability criterion as a smooth function of lesion size and contrast ratio. The model took the following form:
logit(Pdetect) = β0 + β1S + β2C + β3(S X C)     —Equation 1
where S is the lesion diameter, and C is the contrast. This enabled the creation of a continuous probability surface.

Bootstrap resampling was used to estimate uncertainty in AUC for each parameter combination. The standard deviation of the bootstrap AUC distribution was computed to assess the stability of detectability measurements across noise realizations.

Analysis II Workflow:  Next, to evaluate the physical limits of PET detectability, we designed a controlled simulation to isolate the effect of lesion size on measured contrast recovery. In PET imaging, small lesions appear less intense than their true activity due to limited spatial resolution and partial volume effects. To study this relationship systematically, lesion diameter was varied while all other parameters were held constant.

In our MATLAB simulation:
Synthetic prostate lesions ranging from 2 to 10 mm were generated within a uniform background.
A fixed true lesion-to-background uptake ratio was assigned.
A Gaussian blur was applied to represent the PET system spatial resolution (point spread function).
Poisson noise was optionally added to simulate count-dependent noise in PET images.

The measured lesion-to-background ratio was computed after blurring.
The contrast recovery coefficient (CRC) was calculated to quantify the extent to which true contrast was preserved.
Contrast loss due to spatial resolution was quantified using the CRC:
CRC = (Observed Contrast - 1) / (True Contrast - 1)                                                 –Equation 2
This framework allows direct evaluation of how lesion size, relative to system resolution, affects contrast recovery under controlled conditions (see Figure 4).

Analysis III Workflow: 
Although the benefits of hybrid PET/MRI have been demonstrated, the limits of detectability are mostly determined by PET physics. Understanding how lesion-detection quantification is affected by lesion size, uptake contrast, and noise is essential, regardless of biological variability [12]. Since PSMA is significantly overexpressed on the membranes of prostate cancer cells, PSMA PET tracers show improved detection compared to other PET tracers, such as choline and fluorodeoxyglucose-18 (F-18) [13]. Therefore, the main goal of this experiment was to quantify prostate lesion size as a function of parameters such as noise, resolution, and contrast in a hybrid PSMA PET/MRI scan.
Methodology: We first developed a synthetic MRI cohort using the National Cancer Institute (NCI) Imaging Data Commons (IDC), a cloud-based repository of publicly available, de-identified cancer imaging data, by extracting data from three collections: TCGA-PRAD, PROSTATEx, and QIN-Prostate-RepeatMRI [15, 16]. The cohort was calibrated to published PSMA PET/MRI intraprostatic primary-tumor data from pre-prostatectomy cohorts (Zamboglou 2020, Fendler 2016, Burger 2019, Papp 2021) [16]. This was followed by a literature review to identify three parameters from six published PSMA PET/MRI studies spanning three tracers: PSMA-11, DCFPyL, and PSMA-R2. We recorded scanner resolution as FWHM PET scanner spatial resolution reported in each paper (mm); the lesion-to-background ratio (LBR) was calculated from the SUVmean (intrinsic biological contrast independent of lesion size and scanner resolution) of the tumor divided by the SUVmean of background muscle and the background noise fraction (CoV) from image quality data [17]. As the next step, a realistic PET physics model was used to calculate the minimum detectable lesion diameters for each PSMA study scenario, using the Rose criterion (SNR ≥ 3 for possible detection and SNR ≥ 5 for reliable detection) [10]. Small lesions are blurred into the surrounding tissue, making them appear less intense. This creates the partial-volume effect; we used a Gaussian point spread function (PSF) to model the blur. We assumed that the PET system's resolution is defined by the full width at half maximum (FWHM) [18]. Effective FWHM (FWHM_eff) is the Full Width at Half Maximum (FWHM), a measure of the width of a signal, spectral line, or distribution, defined as the distance between points on a curve where the amplitude is half its maximum value [18]. We then converted FWHM to standard deviation (σ) and adjusted the lesion signal accordingly. 
Combined realistic SNR equations/parameters (Budinger 1978; Soret 2007): 
Physical model:
    FWHM_eff  = √(FWHM_scanner² + FWHM_motion²)   [motion-blurred PSF]    – Equation 3
        RC_3D     = erf(d/2√2σ_eff)³                   [3-D sphere PVE]                               – Equation 4
        N_res     = (d / FWHM_eff)³                     [resolution elements]
        noise_eff = noise_clinical / √N_res             [effective ROI noise]                         – Equation 5
        SNR       = (LBR · RC_3D − 1) / noise_eff                                                     – Equation 6
                  = (LBR · RC_3D − 1) · [(d/FWHM_eff)1.5 / noise_clinical]


We used FWHM_motion = 2.5 mm  (pelvic PET respiratory motion; Nehmeh 2002) and noise_clinical = 0.20 (CoV in patients for real-world prostate PET/MRI is ~0.15-0.25). 

References:

​​Sung H, Ferlay J, Siegel RL, Laversanne M, Soerjomataram I, Jemal A, Bray F. Global Cancer Statistics 2020: GLOBOCAN Estimates of Incidence and Mortality Worldwide for 36 Cancers in 185 Countries. CA Cancer J Clin. 2021 May;71(3):209-249. doi: 10.3322/caac.21660. Epub 2021 Feb 4. PMID: 33538338.
Leslie SW, Soon-Sutton TL, Skelton WP. Prostate Cancer. [Updated 2024 Oct 4]. In: StatPearls [Internet]. Treasure Island (FL): StatPearls Publishing; 2025 Jan-. Available from: https://www.ncbi.nlm.nih.gov/books/NBK470550/
US Preventive Services Task Force; Grossman DC, Curry SJ, Owens DK, Bibbins-Domingo K, Caughey AB, Davidson KW, Doubeni CA, Ebell M, Epling JW Jr, Kemper AR, Krist AH, Kubik M, Landefeld CS, Mangione CM, Silverstein M, Simon MA, Siu AL, Tseng CW. Screening for Prostate Cancer: US Preventive Services Task Force Recommendation Statement. JAMA. 2018 May 8;319(18):1901-1913. doi: 10.1001/jama.2018.3710. Erratum in: JAMA. 2018 Jun 19;319(23):2443. doi: 10.1001/jama.2018.7453. PMID: 29801017.
Michael C.M. Gammel, Esteban L. Solari, Matthias Eiber, Isabel Rauscher, Stephan G. Nekolla,  A Clinical Role of PET-MRI in Prostate Cancer?,  Seminars in Nuclear Medicine,  Volume 54, Issue 1,  2024,  Pages 132-140,  ISSN 0001-2998,  https://doi.org/10.1053/j.semnuclmed.2023.08.001.
Evaluation of Prostate Cancer with PET/MRI Liza Lindenberg, Mark Ahlman, Baris Turkbey, Esther Mena, Peter Choyke Journal of Nuclear Medicine Oct 2016, 57 (Supplement 3) 111S-116S; DOI: 10.2967/jnumed.115.169763
Moses WW. Fundamental Limits of Spatial Resolution in PET. Nucl Instrum Methods Phys Res A. 2011 Aug 21;648 Supplement 1:S236-S240. doi: 10.1016/j.nima.2010.11.092. PMID: 21804677; PMCID: PMC3144741.
Bayerlein R, Spencer BA, Abdelhafez YG, Cherry SR, Badawi RD, Omidvari N. Numerical investigation reveals challenges in measuring the contrast recovery coefficients in PET. Phys Med Biol. 2023 Oct 26;68(21):10.1088/1361-6560/ad00fa. doi: 10.1088/1361-6560/ad00fa. PMID: 37802064; PMCID: PMC10798005.
Zuley, M. L., Jarosz, R., Drake, B. F., Rancilio, D., Klim, A., Rieger-Christ, K., & Lemmerman, J. (2016). TCGA-PRAD (Prostate Adenocarcinoma) [Dataset]. The Cancer Imaging Archive (TCIA). https://www.cancerimagingarchive.net/collection/tcga-prad/
Farquhar TH, Llacer J, Sayre J, Tai YC, Hoffman EJ. ROC and LROC analyses of the effects of lesion contrast, size, and signal-to-noise ratio on detectability in PET images. J Nucl Med. 2000 Apr;41(4):745-54. PMID: 10768578.
Adler, S., Seidel, J., Pomper, M., Frey, E., Nadeem, S., Macura, K. J., & Maass-Moreno, R. (2017). Minimum lesion detectability as a measure of PET system performance. EJNMMI Physics, 4(1), 13. https://doi.org/10.1186/s40658-017-0179-2
Zhang YQ, Hu PC, Wu RZ, Gu YS, Chen SG, Yu HJ, Wang XQ, Song J, Shi HC. The image quality, lesion detectability, and acquisition time of 18F-FDG total-body PET/CT in oncological patients. Eur J Nucl Med Mol Imaging. 2020 Oct;47(11):2507-2515. doi: 10.1007/s00259-020-04823-w. Epub 2020 May 18. PMID: 32424483.
Ehman, E. C., Johnson, G. B., Villanueva-Meyer, J. E., Cha, S., Leynes, A. P., Larson, P. E. Z., & Hope, T. A. (2017). PET/MRI: Where might it replace PET/CT?. Journal of magnetic resonance imaging : JMRI, 46(5), 1247–1262. https://doi.org/10.1002/jmri.25711
Hoffman, A., & Amiel, G. E. (2023). The Impact of PSMA PET/CT on Modern Prostate Cancer Management and Decision Making—The Urological Perspective. Cancers, 15(13), 3402. https://doi.org/10.3390/cancers15133402
Chen, Z., Kim, E., Davidsen, T., & Barnholtz-Sloan, J. S. (2024). Usage of the National Cancer Institute Cancer Research Data Commons by Researchers: A Scoping Review of the Literature. JCO clinical cancer informatics, 8, e2400116. https://doi.org/10.1200/CCI.24.00116
Fedorov, A., Longabaugh, W. J. R., Pot, D., Clunie, D. A., Pieper https://doi.org/10.1148/rg.230180
Zhao, J., Hamm, B., Brenner, W., & Makowski, M. R. (2020). Lesion-to-background ratio threshold value of SUVmax of simultaneous [68Ga]Ga-PSMA-11 PET/MRI imaging in patients with prostate cancer. Insights into imaging, 11(1), 137. https://doi.org/10.1186/s13244-020-00926-y
Michael C.M. Gammel, Solari, E. L., Matthias Eiber, Rauscher, I., & Nekolla, S. G. (2024). A Clinical Role of PET-MRI in Prostate Cancer? Seminars in Nuclear Medicine, 54(1), 132–140. https://doi.org/10.1053/j.semnuclmed.2023.08.001
Soret, M., Bacharach, S. L., & Buvat, I. (2007). Partial-volume effect in PET tumor imaging. Journal of Nuclear Medicine: Official Publication, Society of Nuclear Medicine, 48(6), 932–945. https://doi.org/10.2967/jnumed.106.035774
