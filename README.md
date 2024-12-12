# NIDIO - Netherlands Integrated Data Infrastructure of Inequality in Organizations

Stata code to prepare and analyze Dutch administrative register data in the CBS Microdata RA environment.

Version: V1.0

GitHub: [github.com/christophjanietz/NIDIO-Code](github.com/christophjanietz/NIDIO-Code)

OSF: [osf.io/9b2xh](osf.io/9b2xh)

## NIDIO in short

NIDIO is an open-source code infrastructure assisting with the use of Dutch administrative register data. It is built around administrative data provided by Statistics Netherlands (CBS) in the Microdata Services Remote Access Environment (RA). NIDIO facilitates the study of inequality within and between Dutch organizations by integrating various administrative source data into a harmonized three-level data structure (organizations, individuals, and jobs). NIDIO helps to reconstruct workers’ demographic profiles and employment outcomes (e.g., wages) and links them to organizational characteristics.

NIDIO achieves these aims by addressing three challenges that are commonly encountered while working with linked employer-employee register data:

1. Preparing and linking administrative data sources involves several decision-making steps that often remain undisclosed in published research. NIDIO provides transparent data processing routines that improve the reproducibility of completed analyses.
2. Users with limited prior experience working with linked employer-employee register data face high startup barriers during project setup. NIDIO eases time- and labor-intensive data processing by providing tailor-made and customizable installation tools.
3. Translating administrative data into social science concepts and measures is a nontrivial task. NIDIO provides guidelines and best practices to bridge the gap between administrative and scientific data.

NIDIO is managed by Christoph Janietz (c.janietz@rug.nl) and Zoltán Lippényi (z.lippenyi@rug.nl) at the University of Groningen. The NIDIO code was developed by Christoph Janietz and Zoltán Lippényi as part of the NWO-funded project "Beyond Boardrooms". This research was funded by an NWO Talent Scheme VIDI grant (project number: [VI.Vidi.211.231](https://www.nwo.nl/en/projects/vividi211231)).

## Quick Installation Guide within the CBS RA Environment
NIDIO is installed by performing the following steps:

1. Place the NIDIO folder in your project drive (H:/) within the CBS RA environment.
   
2. Open the do-file *install_NIDIO.do*. You can find this file in the root directory **../NIDIO/** of the NIDIO file tree. Your working directory in STATA must be identical to the NIDIO root directory.
   
3. Execute the do-file *install_NIDIO.do*. Running the lines 10 and 11 of the do-file is mandatory. Executing these lines will locate and call the source data within the CBS RA environment. You can customize the rest of your installation by using the command install_nidio together with one specified NIDIO module you wish to install. For example, to install the module 'ABR', execute: install_nidio ABR
   
4. NIDIO will now be busy processing the CBS source data. This can take between 1 minute (module 'PARTNER') to 4 days (96 hours) (module 'SPOLIS_YEAR') depending on the selected module.
   
5. You will receive a notification in the STATA results window, when the installation of the module is complete. You can find the ready-to-use datasets in the corresponding folder under the file path **../NIDIO/Data/[Module]/** after completion. 

## Importing NIDIO into the CBS RA Environment
There are two ways to install NIDIO within the CBS RA Environment:

1. **Download NIDIO as a zip folder from the OSF repository.** The NIDIO code can be retrieved at [https://osf.io/9b2xh/](https://osf.io/9b2xh/). This OSF repository is intended as the main gateway for the distribution of NIDIO. The OSF repository is synchronized with a [GitHub repository](https://github.com/christophjanietz/NIDIO-Code) in which the code is hosted and maintained. It is recommended to download the whole NIDIO folder as a zip via the OSF repository (see Figure \ref{fig:download}).

Users may then contact CBS [microdata@cbs.nl](mailto:microdata@cbs.nl) to request an import of the NIDIO zip folder into their RA project environment.
    
2. **ODISSEI Storage Facility within the CBS Remote Environment.** The very large NIDIO datasets **nidio\_spolis\_month\_2006\_2023.dta** (doi: [10.34894/YQIIQV](https://portal.odissei.nl/dataset.xhtml?persistentId=doi:10.34894/YQIIQV)) and **nidio\_spolis\_year\_2006\_2023.dta** (doi: [10.34894/63XWJB](https://portal.odissei.nl/dataset.xhtml?persistentId=doi:10.34894/63XWJB)) will also be stored directly within the RA environment via the ODISSEI Storage Facility. Researchers at ODISSEI member organisations can request access to these files in their own RA projects (which is free of charge). Projects intending to use these NIDIO datasets need to have access to the original CBS microdata topic (SPOLIS) in their project. The usual fee for accessing the data applies. We expect these files to be available by January 2025. 

### Licence Apache-2
Copyright NIDIO Christoph Janietz 

NIDIO is an open-source code licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

