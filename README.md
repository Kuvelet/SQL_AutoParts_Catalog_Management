# SQL_AutoParts_Catalog_Management

## Project Overview

This project is a complete, SQL-based aftermarket auto parts catalog system developed for both internal operations and external distribution. Designed in full alignment with **ACES and PIES** data standards, it transforms raw vehicle fitment and part data into two key outputs:

- A structured **Buyers Guide** covering precise vehicle-part application mapping

- A comprehensive **MasterCross**, which unifies OEM and aftermarket competitor part numbers for each part

I built this system to replace my company’s fragmented and manually maintained catalog with a **fully autonomous, scalable solution**. It enables structured updates using raw input tables maintained by the R&D team—streamlining the integration of new part introductions, vehicle fitments, and cross-reference relationships.

As a result, the catalog’s **accuracy improved, manual workload decreased**, and **data sharing with sales teams and customers became significantly faster and more reliable.**

---

## Tech Stack

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- ACES / PIES Data Format

The solution is fully database-native, requiring no external tools or languages to operate or maintain the catalog pipeline.

---

## Dataset Description

###  ACES/PIES Data Overview

The dataset for this project consists of two distinct yet interconnected components: the foundational **AAIA ACES/PIES** data, and company-specific catalog data. Each serves a unique purpose in creating a comprehensive automotive parts catalog.

#### 🔹 1. AAIA ACES/PIES Data (Industry Standard)

The Automotive Aftermarket Industry Association (**AAIA**) provides standardized vehicle fitment and application data using the **ACES (Aftermarket Catalog Exchange Standard)** and **PIES (Product Information Exchange Standard)** frameworks. This foundational dataset includes:

- **Vehicle Identification and Attributes**  
  `Make`, `Model`, `Year`, `SubModel`, `BodyType`, `VehicleType`, `BodyNumDoors`, `DriveTypeName`, etc.

- **Engine and Performance Data**  
  `EngineBaseID`, `Liter`, `Cylinders`, `AspirationName`, `FuelTypeName`

- **Technical Specifications**  
  `TransmissionControlTypeName`, `SteeringSystemName`, `BrakeABSName`, `CylinderHeadTypeName`

This data ensures industry-wide consistency and compatibility, forming the base upon which the catalog is structured.

####  2. Company-Specific Catalog Data (Internally Generated)

On top of the ACES/PIES structure, I’ve augmented the dataset with company-specific part information tailored for our internal catalog system. This includes:

- **Product Identification**  
  `TSPARTID`, `TSPARTIDLR`, `AAIAPARTTERMINOLOGY`, `AAIAPOSITION`

- **Inventory and Localization**  
  `QUANTITY`, `MEXICO`, `CanK`

- **Fitment and Interchangeability Details**  
  `Opposite_Side_PARTID`, `Submodel_RockAuto`, `COMMENTS`, `DETAILS`

These fields provide the detailed part-level resolution needed to drive accurate Buyers Guide generation and SKU-to-vehicle mapping.

####  Why Combine AAIA and Company Data?

Merging these two data sources enables a powerful, dual-purpose catalog system:

- **Industry Alignment**  
  Maintains compatibility with external systems, buyers, and data-sharing partners using the AAIA standard.

- **Operational Precision**  
  Enhances internal accuracy in product mapping, inventory alignment, and vehicle fitment validation.

This hybrid dataset design lays the foundation for a scalable, autonomous, and high-integrity catalog system purpose-built for real-world use.

**Sample ACES/PIES Data (1991 Nissan Pathfinder Example):**

| RegionID | Make | Model | Year | SubModel | VehicleType | FuelTypeName | DriveTypeName | TransmissionControlTypeName | BodyType | BodyNumDoors | BaseVehicleID | AspirationName | EngineBaseID | Liter | CC | CID | Cylinders | BlockType | SteeringSystemName | SteeringTypeName | VehicleID | BodyTypeID | BodyNumDoorsID | DriveTypeID | BrakeABSName | CylinderHeadTypeName |
|----------|------|-------|------|----------|-------------|--------------|---------------|-----------------------------|----------|--------------|---------------|----------------|--------------|-------|----|-----|-----------|-----------|--------------------|------------------|-----------|------------|----------------|-------------|--------------|----------------------|
| 1 | Nissan | Pathfinder | 1991 | SE | Truck | GAS | 4WD | Automatic | Sport Utility | 4 | 12345 | Naturally Aspirated | 678 | 3.0 | 2960 | 181 | 6 | V | Power | Rack & Pinion | 54321 | 5 | 4 | 4 | 4-Wheel ABS | SOHC |

> The sample data has been anonymized and simplified for demonstration purposes only.

Building upon the ACES/PIES structure, I've integrated our company's specific part number information to generate our comprehensive raw catalog dataset. This augmented dataset is the cornerstone for the final catalog generation.

**Example of Our Augmented Raw Catalog Data (1991 Nissan Pathfinder Example):**

| MAKE | MODEL | BodyType | Year | SUBMODEL | VehicleType | BodyNumDoors | MfrBodyCode | YrMax | COMMENTS | DETAILS | AAIAPARTTERMINOLOGY | AAIAPOSITION | QUANTITY | TSPARTID | TSPARTIDLR | MEXICO | Liter | Cylinders | AspirationName | FuelTypeName | DriveTypeName | Submodel_RockAuto | CanK | Opposite_Side_PARTID |
|------|-------|----------|------|----------|-------------|--------------|-------------|-------|----------|---------|--------------------|--------------|----------|----------|------------|--------|-------|-----------|----------------|--------------|---------------|-------------------|------|----------------------|
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Liftgate Lift Support | NULL | 2 | 611321 | 611321 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | NULL |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Left | 1 | 612921 | 612921 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612917 |
| Nissan | Pathfinder | Sport Utility | 1991 | SE | Truck | 4 | NULL | 1991 | NULL | NULL | Back Glass Lift Support | Right | 1 | 612917 | 612917 | YES | 3.0 | 6 | Naturally Aspirated | GAS | 4WD | SE | YES | 612921 |

> The sample data has been anonymized and simplified for demonstration purposes only.

This enhanced dataset forms the backbone of the system—supporting precise vehicle fitment logic, structured catalog assembly, and rich Buyers Guide generation.

###  MasterCross Data Overview

In the automotive parts industry—especially for manufacturers and wholesalers—**accurate part identification** is critical. With a wide array of vehicle makes, models, and submodels (often varying by region), ensuring correct part-to-vehicle matching is essential for both operational efficiency and customer satisfaction.

OEM (Original Equipment Manufacturer) numbers serve as the industry’s primary standard for part identification. However, in the aftermarket world, customers often request quotes using **OEM references** or **aftermarket competitor part numbers**. To respond effectively, sellers must maintain a detailed, organized system of cross-references that map each internal part to all available equivalent numbers across the market.

This comprehensive cross-referencing dataset—often referred to as the **Master Cross**—enables:

-  Accurate customer quoting  
-  Faster catalog lookup and matching  
-  Seamless integration with third-party buyer systems  
-  Greater catalog integrity and internal data consistency

####  Original Challenge

Prior to this project, the Master Cross was managed **manually** in Microsoft Access. Each new part or cross-reference was entered by hand—resulting in inefficiencies, inconsistencies, and missed opportunities to automate key catalog processes.

To modernize this workflow, I first **unpivoted and normalized** the manually compiled table to extract only the relevant cross-reference information. This laid the foundation for building a clean, scalable structure where each part's crosses—OEM and aftermarket—could be properly grouped, analyzed, and exported.


####  Sample Master Cross Dataset (Condensed Example)

| Make  | OEM #        | OEM Cond #   | TSPARTID | TSPARTIDLR | Monroe # | Stabilus # | AC Delco # | Bugiad # | Liftgate # | Meyle # | FCS #   | Delphi # | LesjCond # | Notes |
|-------|--------------|--------------|----------|------------|----------|------------|------------|----------|-------------|---------|---------|-----------|-------------|-------|
| TOYOTA | 53450-A9030 | 53450A9030   | 613593   | 613593     | 901393   | 461510     | 4326       | LS10116  | SG329011    | 013610  | 84326   | DMA       |             |       |
| TOYOTA | 53450-69045 | 5345069045   | 613593   | 613593     | 901393   | 461510     | 4326       | LS10116  | SG329011    | 013610  | 84326   | DMA       |             |       |
| TOYOTA | 53440-YC040 | 53440YC040   | 613593   | 613593     | 901393   | 461510     | 4326       | LS10116  | SG329011    | 013610  | 84326   | DMA       |             |       |
| TOYOTA | 53440-YC020 | 53440YC020   | 613593   | 613593     | 901393   | 461510     | 4326       | LS10116  | SG129032    | 013610  | 84326   | DMA       |             |       |

>  *Note: This table has been simplified and pseudonymized to demonstrate the schema and logic only. The original dataset contains tens of thousands of crosses and brand mappings across over 15,000+ unique SKUs.*


By automating and structuring the Master Cross using SQL, I enabled my company to:

-  Eliminate repetitive manual entry  
-  Support scalable cross-reference expansion  
-  Export unified catalogs for clients, quotes, and internal systems

This Master Cross now functions as a **core component of our catalog logic**, linking each internal TSPARTID to a complete set of competitor and OEM numbers used across the industry.

--- 

## Buyers Guide Construction & Cross Integration

To build a complete and distributable aftermarket catalog, I designed a two-stage process:

### Step 1: Build the Buyers Guide from Application Fitment Data

The Buyers Guide is constructed by transforming raw ACES-style application data into a structured format that maps each **vehicle configuration** to a specific **internal part number (TSPARTID)**.

This process includes:

-  Filtering out incomplete or deprecated entries
-  Grouping applications by year range, submodel, and body type
-  Ensuring 1-to-1 or 1-to-many relationships between part numbers and fitments
-  Formatting the output to match industry-exchange standards

This results in a **vehicle application table** with part IDs, ready to be enhanced with cross-references.

**Script**

```sql
WITH UniqueTSPARTID AS (
    SELECT DISTINCT
        TSPARTID
    FROM TUF_CATALOG_AAIA
),

ApplicationInfo AS (
    SELECT
        TSPARTID,
        CASE 
            WHEN COUNT(CASE WHEN MAKE = 'UNIVERSAL' THEN 1 END) > 0 THEN 'Universal'
            ELSE STRING_AGG(MAKE + ': ' + ModelInfo, '  / ')
        END AS Application,
        MIN(MinYear) AS MinYear,
        MAX(MaxYear) AS MaxYear
    FROM (
        SELECT
            TSPARTID,
            MAKE,
            STRING_AGG(CONCAT(MODEL, ' (', MinYear, '–', MaxYear, ')'), '; ') AS ModelInfo,
            MIN(MinYear) AS MinYear,
            MAX(MaxYear) AS MaxYear
        FROM (
            SELECT
                TSPARTID,
                MAKE,
                MODEL,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            GROUP BY TSPARTID, MAKE, MODEL
        ) AS ModelYearRanges
        GROUP BY TSPARTID, MAKE
    ) AS ModelsGroupedWithYearRanges
    GROUP BY TSPARTID
),

AggregatedBodyType AS (
    SELECT
        BodyInfo.TSPARTID,
        STRING_AGG(
            CASE 
                WHEN BodyRangeSummary.HasMultipleRanges = 0 THEN BodyInfo.BodyInfo
                ELSE CONCAT(BodyInfo.BodyInfo, ' (', BodyInfo.MinYear, '–', BodyInfo.MaxYear, ')')
            END,
            ', '
        ) AS BodyType
    FROM (
        SELECT
            TSPARTID,
            BodyNumDoors + ' Door ' + BodyType AS BodyInfo,
            MIN([Year]) AS MinYear,
            MAX([Year]) AS MaxYear
        FROM TUF_CATALOG_AAIA
        WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
        GROUP BY TSPARTID, BodyNumDoors, BodyType
    ) AS BodyInfo
    JOIN (
        SELECT
            TSPARTID,
            CASE 
                WHEN COUNT(DISTINCT CAST(MinYear AS VARCHAR) + '-' + CAST(MaxYear AS VARCHAR)) > 1 THEN 1
                ELSE 0
            END AS HasMultipleRanges
        FROM (
            SELECT
                TSPARTID,
                BodyNumDoors,
                BodyType,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
            GROUP BY TSPARTID, BodyNumDoors, BodyType
        ) AS Ranges
        GROUP BY TSPARTID
    ) AS BodyRangeSummary
        ON BodyInfo.TSPARTID = BodyRangeSummary.TSPARTID
    GROUP BY BodyInfo.TSPARTID, BodyRangeSummary.HasMultipleRanges
),

AggregatedNotes AS (
    SELECT 
        MBC.TSPARTID,
        MBC.MfrBodyCode,
        C.Cmnts AS Comments,
        D.Dtls AS Details,
        TRIM(' || ' FROM
            CASE WHEN MBC.MfrBodyCode IS NOT NULL AND MBC.MfrBodyCode <> '' THEN MBC.MfrBodyCode + ' || ' ELSE '' END +
            CASE WHEN C.Cmnts IS NOT NULL AND C.Cmnts <> '' THEN C.Cmnts + ' || ' ELSE '' END +
            CASE WHEN D.Dtls IS NOT NULL AND D.Dtls <> '' THEN D.Dtls ELSE '' END
        ) AS Notes
    FROM (
        SELECT 
            TSPARTID,
            STRING_AGG(MfrBodyCode, '; ') AS MfrBodyCode
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                MfrBodyCode
            FROM TUF_CATALOG_AAIA
            WHERE MfrBodyCode IS NOT NULL
        ) AS x
        GROUP BY TSPARTID
    ) AS MBC
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(COMMENTS, '; ') AS Cmnts
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                COMMENTS
            FROM TUF_CATALOG_AAIA
            WHERE COMMENTS IS NOT NULL
        ) AS y
        GROUP BY TSPARTID
    ) AS C ON MBC.TSPARTID = C.TSPARTID
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(DETAILS, '; ') AS Dtls
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                DETAILS
            FROM TUF_CATALOG_AAIA
            WHERE DETAILS IS NOT NULL
        ) AS z
        GROUP BY TSPARTID
    ) AS D ON MBC.TSPARTID = D.TSPARTID
    WHERE 
        C.Cmnts IS NULL AND
        MBC.MfrBodyCode IS NOT NULL AND
        D.Dtls IS NOT NULL
),

AggregatedTerminology AS (
    SELECT
        TSPARTID,
        (
            SELECT STRING_AGG(AAIAPARTTERMINOLOGY, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, AAIAPARTTERMINOLOGY
                FROM TUF_CATALOG_AAIA
            ) AS DistinctTerminology
            WHERE DistinctTerminology.TSPARTID = base.TSPARTID
        ) AS PartTerminology,

        (
            SELECT STRING_AGG(AAIAPOSITION, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, AAIAPOSITION
                FROM TUF_CATALOG_AAIA
            ) AS DistinctPosition
            WHERE DistinctPosition.TSPARTID = base.TSPARTID
        ) AS Position,

        (
            SELECT STRING_AGG(QUANTITY, '; ')
            FROM (
                SELECT DISTINCT TSPARTID, QUANTITY
                FROM TUF_CATALOG_AAIA
            ) AS DistinctQuantity
            WHERE DistinctQuantity.TSPARTID = base.TSPARTID
        ) AS QuantityNeeded
    FROM (
        SELECT DISTINCT TSPARTID
        FROM TUF_CATALOG_AAIA
    ) AS base
)

SELECT 
    UniqueTSPARTID.TSPARTID AS TSPARTID,
    ApplicationInfo.Application AS Application,
    ApplicationInfo.MinYear AS MinYear,
    ApplicationInfo.MaxYear AS MaxYear,
    AggregatedBodyType.BodyType AS BodyType,
    AggregatedTerminology.PartTerminology AS PartTerminology,
    AggregatedTerminology.Position AS Position,
    AggregatedNotes.Notes AS Notes,
    AggregatedTerminology.QuantityNeeded AS QuantityNeeded
FROM UniqueTSPARTID
LEFT JOIN ApplicationInfo 
    ON UniqueTSPARTID.TSPARTID = ApplicationInfo.TSPARTID
LEFT JOIN AggregatedBodyType 
    ON UniqueTSPARTID.TSPARTID = AggregatedBodyType.TSPARTID
LEFT JOIN AggregatedNotes 
    ON UniqueTSPARTID.TSPARTID = AggregatedNotes.TSPARTID
LEFT JOIN AggregatedTerminology
    ON UniqueTSPARTID.TSPARTID = AggregatedTerminology.TSPARTID
```

This SQL script builds a summarized application table for each unique `TSPARTID` (part number). It combines:

- Vehicle fitment information (make, model, year ranges)
- Body type formatting
- Position, quantity, and part terminology (based on AAIA standards)
- Comments and details
- A final SELECT that outputs a human-readable, enriched catalog row per part

---

### 🔹 1. `UniqueTSPARTID`
Gets all distinct part numbers from the source table `TUF_CATALOG_AAIA`. Serves as the anchor for joining later data.

---

### 🔹 2. `ApplicationInfo`
Builds a vehicle fitment string for each part:

- If the part is labeled `UNIVERSAL`, returns 'Universal'.
- Otherwise, constructs grouped strings like:
  
  `Nissan: Pathfinder (1991–1992); Altima (1995–1998) / Toyota: Camry (2001–2004)`

This involves nested aggregation:
- First by `MAKE`, `MODEL`, `Year`
- Then grouped into brand-level fitment strings
- Then collapsed per part

---

### 🔹 3. `AggregatedBodyType`
Summarizes body configurations like:

`2 Door Coupe (1995–2001), 4 Door Sedan (2002–2004)`

- If only one year range: just show `2 Door Coupe`
- If multiple ranges per body type: add `(Year–Year)` for clarity

---

### 🔹 4. `AggregatedNotes`
Combines:
- Manufacturer body codes (`MfrBodyCode`)
- Comments (`COMMENTS`)
- Details (`DETAILS`)

Example output:

`ABC123 || Fits limited edition only || Reinforced bracket design`

Uses `STRING_AGG` and `TRIM` to format cleanly.

---

### 🔹 5. `AggregatedTerminology`
Aggregates key AAIA-style catalog fields per part:
- `PartTerminology` (e.g., Lift Support)
- `Position` (e.g., Left, Right)
- `QuantityNeeded` (e.g., 1, 2)

Uses nested `DISTINCT` and `STRING_AGG` for clean deduplication.

---

### 🧾 Final SELECT

Returns a unified view with:
- `TSPARTID`
- `Application` string
- Min and max fitment years
- Body type string
- Position, terminology, and quantity
- Combined comments + codes + details in `Notes`

This final output is the basis of the Buyers Guide table or export.

### 🔄 Step 2: Unpivot and Normalize the Master Cross Data

The original cross-reference table contained over 50 columns of competitor and OEM brands in a wide format. To make it usable:

- I **unpivoted the table** using SQL to convert all brand columns into rows
- Removed null, duplicate, and placeholder values
- Mapped each cross-reference to its corresponding `TSPARTID`
- Classified the source type (OEM, aftermarket, conditional, etc.)

This generated a **flat, normalized CrossMaster** table for easy joins and exports.


### 🔗 Step 3: Combine Buyers Guide with Master Cross

The final step is to **enrich the Buyers Guide** by joining it with the normalized CrossMaster using `TSPARTID` as the key.

This produces a catalog where each vehicle-part application is associated with:

- The internal part number (`TSPARTID`)
- All known OEM and aftermarket equivalent numbers
- Any opposite-side or regional variations

This structure supports **both internal lookup** and **external sharing** with customers, resellers, and catalog distributors.






