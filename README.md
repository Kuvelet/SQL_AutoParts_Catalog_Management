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

#### 🏗 Buyers Guide View: `vw_TUF_BuyersGuide_All_woCross`

This SQL script defines a view that assembles a **comprehensive Buyers Guide** table for your catalog. Each row summarizes the full application, terminology, and essential notes for a unique part number (`TSPARTID`), drawing from your ACES-style raw fitment data.


 **What This View Does**

- **Gathers all part numbers** from the catalog
- **Aggregates all fitment applications** (make, model, year, etc.)
- **Summarizes body types and configurations**
- **Combines relevant notes, comments, and codes**
- **Lists AAIA part terminology, position, and quantity**

The result:  
A single, well-structured table providing every key Buyers Guide detail needed for internal analysis, catalog exports, or sharing with partners—**before joining to any cross-reference data**.

**SCRIPT "vw_TUF_BuyersGuide_All_woCross"**

```sql
CREATE VIEW vw_TUF_BuyersGuide_All_woCross AS
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


**Step-by-Step Explanation**

##### 1. `UniqueTSPARTID`
- Pulls every unique part number in the catalog.

##### 2. `ApplicationInfo`
- For each part, aggregates all fitment applications into a readable string like:  
  `Nissan: Pathfinder (1991–1995); Altima (1996–1998) / Toyota: Camry (2000–2002)`
- Handles “Universal” fitments as a special case.

##### 3. `AggregatedBodyType`
- Summarizes all body types (e.g., “4 Door SUV (1991–1995)”).
- Adds year ranges for body types that change over time.

##### 4. `AggregatedNotes`
- Combines manufacturer body codes, comments, and details.
- Only non-empty values are concatenated, separated by `||`.

##### 5. `AggregatedTerminology`
- Lists AAIA part terminology (e.g., “Lift Support”), position (“Left; Right”), and quantity needed.

##### 6. **Final SELECT**

- Joins all the above CTEs using `TSPARTID` as the key.
- Each row = one part, with full application and descriptive metadata.
- This view is ready for downstream joins (e.g., to your Master Cross table) or as a Buyers Guide export.

**Sample Output Columns**

| Column           | Description                                             |
|------------------|---------------------------------------------------------|
| TSPARTID         | Internal catalog part number                            |
| Application      | Complete fitment string (Make, Model, Year)             |
| MinYear/MaxYear  | Earliest and latest fitment years                       |
| BodyType         | Detailed body/door summary with years if needed         |
| PartTerminology  | AAIA standard terminology (e.g., Lift Support)          |
| Position         | Position information (e.g., Left, Right)                |
| Notes            | Combined notes, codes, comments                         |
| QuantityNeeded   | Quantity required per vehicle                           |


#### **Resulting Table**

| TSPARTID | Application                                                                                                                                                                  | MinYear | MaxYear | BodyType                                                                                  | PartTerminology        | Position | Notes             | QuantityNeeded |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|---------|-------------------------------------------------------------------------------------------|------------------------|----------|-------------------|---------------|
| 611049   | Ford: Taurus (1996–1999)  / Mercury: Sable (1996–2005)                                                                                | 1996    | 2005    | 4 Door Wagon                                                                              | Liftgate Lift Support  |          | E54D; ME54D       | 2             |
| 611050   | Chevrolet: Silverado 2500 HD (2020–2024); Silverado 3500 HD (2020–2024)                                                               | 2020    | 2024    | 2 Door Cab & Chassis, 2 Door Standard Cab Pickup, 4 Door Cab & Chassis, 4 Door Crew Cab Pickup, 4 Door Extended Cab Pickup | Hood Lift Support      |          | Gas Engine        | 2             |
| 611053   | Cadillac: Eldorado (1992–2002); Seville (1992–1996)                                                                                   | 1992    | 2002    | 2 Door Coupe (1992–2002), 2 Door Sedan (1995–1997), 4 Door Sedan (1992–1996)              | Hood Lift Support      |          |                   | 2             |
| 611054   | Audi: Q2 (2017–2022); Q2 Quattro (2018–2022)                                                                                          | 2017    | 2022    | 4 Door Sport Utility                                                                      | Liftgate Lift Support  |          | GAB \|\| w/ Manual| 2             |
| 611055   | Mercedes-Benz: CLS-Class (2008–2011)                                                                                                  | 2008    | 2011    | 4 Door Coupe                                                                              | Trunk Lid Lift Support |          | CL203             | 2             |
| 611056   | Volkswagen: Arteon (2017–2022)                                                                                                        | 2017    | 2022    | 4 Door Hatchback                                                                          | Liftgate Lift Support  |          | w/o Power         | 2             |
| 611057   | Chrysler: Caravan (1984–1990); Town & Country (1984–1990)  / Dodge: Caravan (1984–1990); Grand Caravan (1984–1990)  / Plymouth: Grand Voyager (1987–1990); Voyager (1984–1990) | 1984    | 1990    | 3 Door Mini Passenger Van, 4 Door Mini Passenger Van                                      | Liftgate Lift Support  |          |                   | 2             |


---

### Step 2.1 Cross Reference Integration: Normalizing the Master Cross

In legacy catalog management, cross-reference tables are often assembled and updated manually. Each brand or cross type is represented as a separate column, leading to a fragmented and inefficient structure. This approach—while common in small or legacy operations—quickly becomes unmanageable as the catalog scales, especially when:

- New competitor crosses, superseding OE numbers, or regional variations are introduced
- Individual parts map to multiple crosses, resulting in row duplication and data redundancy
- Manual edits propagate inconsistencies over time

**Initial State:**  
Each brand had its own column in the cross-reference table. If a part corresponded to multiple competitor numbers or OE supersessions, duplicate rows were created to capture all possible crosses. The result was a wide, repetitive, and error-prone dataset that hampered both automation and reliable lookups.


The Transformation Challenge

To modernize and streamline the catalog, my first priority was to **normalize** the cross-reference data—**flattening** the table and eliminating duplicates. My solution was to create a view called `vw_TUF_Unpivoted_IntMaster_wMake`, which programmatically unpivots the legacy wide-format table into a clean, analytical structure with only three key columns:

- `TSPARTID` — Our internal part number  
- `Crossname` — The competitor or OE cross-reference number  
- `Make` — The brand or source of the cross (e.g., Monroe, Stabilus, AC Delco, OE, etc.)

This restructuring is a **one-time process** that converts years of inconsistent manual data entry into a robust and query-friendly format, providing a foundation for further automation and ongoing catalog maintenance.


**Benefits of the Normalized Structure**

- **Efficiency:** Drastically reduces manual management and maintenance workload  
- **Consistency:** Eliminates duplicates, ambiguity, and human error  
- **Scalability:** Supports effortless integration of new crosses or brands  
- **Automation Ready:** Enables seamless joins with Buyers Guide and downstream analytics

The resulting unpivoted dataset, maintained via the `vw_TUF_Unpivoted_IntMaster_wMake` view, is now the authoritative source for all future cross-reference updates, exports, and integrations.

**SCRIPT "vw_TUF_Unpivoted_IntMaster_wMake"**

```sql
CREATE VIEW [dbo].[vw_TUF_Unpivoted_IntMaster_wMake]
AS
SELECT DISTINCT 
    Unpivoted.TSPARTID, 
    Unpivoted.CrossName, 
    Unpivoted.CrossingNumber, 
    TUF_IntMaster.Make
FROM (
    SELECT DISTINCT 
        TSPARTID, 
        CrossName, 
        CrossingNumber
    FROM TUF_IntMaster
    UNPIVOT (
        CrossingNumber FOR CrossName IN (
            [OEM], [SA], [Sachs], [Mightylift], [FCS], [Stabilus], [Martas], [URO], [TRW], 
            [Monroe], [Napa], [QH], [Helmer], [Piston], [Kilen], [Optimal], [Meyle], [MagMar], 
            [Ferron], [Febi], [Lip], [AC_Delco], [Decar], [Liftgate], [Bugiad], [Triscan], 
            [Les], [FA], [Delphi], [Hans_Pries], [Vierol], [Mapco], [Destek], [Cofap], 
            [Air_Kraft], [Arnott], [MonroeEUR], [AMS], [Johns], [Klaxcar], [SYD], [DMA], 
            [Auger], [Sampa], [Sem_Plastik], [Stellox], [Orex], [DT_Spare_Parts], [Veka]
        )
    ) AS A
    WHERE CrossingNumber IS NOT NULL
) AS Unpivoted
LEFT JOIN TUF_IntMaster 
    ON Unpivoted.CrossingNumber = TUF_IntMaster.OEM;
```

This SQL view performs the essential **unpivoting and normalization** of the legacy Master Cross table (`TUF_IntMaster`). The goal is to convert the old, wide-format table (where each cross brand is a column) into a **clean, flat, and analytical table**—making downstream processing and joining far more efficient.


#### **Step-by-Step Logic**

##### 1. **UNPIVOT the Table**

- The `UNPIVOT` operation transforms multiple cross-reference columns (e.g., `[OEM]`, `[Monroe]`, `[Stabilus]`, etc.) into two columns:
  - `CrossName`: The brand or source of the cross (column name)
  - `CrossingNumber`: The actual competitor or OE number for the cross

**Result:**  
Instead of one wide row with 40+ cross columns, you get **one row per part per cross**, making the dataset "long" and normalized.

##### 2. **Filter Out Null Crosses**

- The `WHERE CrossingNumber IS NOT NULL` clause ensures that only valid, populated cross numbers are included—removing empty, unused, or irrelevant entries.

##### 3. **DISTINCT Selection**

- Both in the subquery and the outer SELECT, `DISTINCT` is used to avoid duplicate rows that could arise from legacy data or multiple identical crosses.

##### 4. **Add the Make**

- The outer query performs a `LEFT JOIN` to the original `TUF_IntMaster` table on `CrossingNumber = OEM`.
- This step pulls in the `Make` (car manufacturer/brand) associated with the OE number for each cross-reference. (If the cross is not an OEM number, `Make` may be NULL.)

##### 5. **Output Columns**

- The resulting view returns:
  - `TSPARTID` (your internal part number)
  - `CrossName` (cross brand or source, e.g., Monroe, OEM, Sachs)
  - `CrossingNumber` (the actual competitor/OE part number)
  - `Make` (brand, if determinable via OEM link)


#### **Resulting Table**

| TSPARTID | CrossName | CrossingNumber | Make   |
|----------|-----------|---------------|--------|
| 613593   | OEM       | 53450-A9030   | TOYOTA |
| 613593   | Monroe    | 901393        | NULL   |
| 613593   | Stabilus  | 461510        | NULL   |
| ...      | ...       | ...           | ...    |


#### **Summary**

This view transforms your legacy, manual cross-reference table into a **clean, query-ready structure**—removing redundancy, supporting automation, and allowing direct joins to Buyers Guide application data for a fully enriched catalog.

### Step 2.2 



