# VANA Forest Intelligence Command Center — Real Data Availability Matrix

Audit date: 2026-09-02. This matrix is restricted to the checked repository, documented public runtime schemas, and read-only live responses. No database connection, migration, ORM model, table name, or record-count endpoint is present in this repository or exposed by the checked APIs; database table names therefore remain **NOT VERIFIED**.

## Evidence audited

| Layer | Verified API | Result | Verified live fields / records |
|---|---|---|---|
| G1 canonical observation | `GET http://163.128.209.18:8013/health` | `200 healthy` | Consumer-facing MasterDB API; no table metadata or list endpoint exposed. |
| G1 record retrieval | `GET /observations/{observation_id}` | `200 RETRIEVED` for a real existing record | `observation_id`, `canonical_record_id`, `dataset_id`, `geo_id`, timestamps, capture/quality state, location, artifact reference/integrity, measurement and measurement provenance. |
| G2 context | `POST https://niyantran.blackholeinfiverse.com/api/group2/context/resolve` | `200` in the live browser chain | `context_id`, ruling/decision, action eligibility, abstention requirement, decision reason when supplied. A public OpenAPI document was not exposed at the checked host path. |
| G4 governance | `GET http://163.128.209.18:8010/health`; `POST /vana/execute` | `200 healthy`; `200 governed_abstention` | `status`, evidence `event_type`, `abstention_record_id`, `event_id`, `execution_id`, ruling, action, governance flag, timestamp, canonical ID. |
| G4 governance summary | `GET /decision-summary`; `GET /recent-activity` | `200`, but empty at audit | `total_decisions`, `last_action`, `success_rate`, `demo_frozen`, `stateless`; recent activity array. Not forest-domain analytics. |

## Feature matrix

| FEATURE | DATA AVAILABLE | SOURCE | API | REQUIRED FIELDS | STATUS |
|---|---|---|---|---|---|
| Executive Overview | Selected observation and governance outcome only; no portfolio totals, alerts, or coverage aggregate | G1 record; G2 decision; G4 execution | G1 `GET /observations/{id}`; G2 resolve; G4 execute | Available: `observation_id`, `canonical_record_id`, `observation_timestamp`, `source_timestamp`, `capture_method`, coordinates, provenance reference, ruling, eligibility, abstention. Missing: observation-list/count, alert feed, coverage aggregate | **LIVE** for selected record; aggregate cards **NOT VERIFIED** |
| Forest Cover | No forest-cover measurement, classification, area, polygon, or trend returned | None exposed | No verified forest-cover API | Required: coverage area/percent, period, district/boundary ID or geometry, source, timestamp | **DATA NOT AVAILABLE** |
| Plantation | No plantation type, progress, survival, location collection, or status field returned | None exposed | No verified plantation API | Required: plantation ID/category, status/progress, area, geometry, timestamp, provenance | **DATA NOT AVAILABLE** |
| Wildlife Monitoring | A general observation record is available; `species` is explicitly `null` in the audited record | G1/Group 3 record | G1 `GET /observations/{id}` | Available: ID, type, timestamp, coordinates, capture method, provenance reference. Missing: species/taxon, wildlife event classification, list feed | **LIVE** for generic record facts; wildlife classification **NOT VERIFIED** |
| Human-Wildlife Conflict | No conflict, severity, alert, victim, or incident-status fields | None exposed | No verified conflict API | Required: incident ID/type, severity, geometry/location, timestamp, alert/governance linkage, provenance | **DATA NOT AVAILABLE** |
| GIS / Live Map | Exact point coordinates and CRS are present in an audited record | G1/Group 3 record | G1 `GET /observations/{id}` | Available: `latitude`, `longitude`, `geo_location.crs`, `geo_id`, timestamp, provenance reference. Missing: boundary layers, district attribution, multi-record map query | **LIVE** point for selected record; layers/district **NOT VERIFIED** |
| Analytics & Reports | Record-level quality/evidence and one returned measurement are available. No verified collection, trend, distribution, or forest aggregate API | G1/Group 3 record | G1 `GET /observations/{id}` | Available: timestamps, quality state, capture method, synthetic state, checksum, `measurements[]` and nested provenance. Missing: list/series endpoint, report catalog, aggregate dimensions | **LIVE** record report; trends/distributions **DATA NOT AVAILABLE** |
| District Detail | `geo_id` and coordinates exist; no district name/code/boundary or aggregate | G1/Group 3 record | G1 `GET /observations/{id}` | Required: verified district ID/name/boundary and district-scoped record, alert, governance queries | **NOT VERIFIED** |
| Forest Produce | No product/category/quantity/value fields | None exposed | No verified forest-produce API | Required: product observation ID/category, quantity, unit, value/currency, location, timestamp, provenance | **DATA NOT AVAILABLE** |
| System Health | Runtime health responses and latest request HTTP statuses are available | G1, G2, G4, UI | G1 `/health`; G2 live resolve result; G4 `/health` and `/vana/execute` | Available: G1/G4 health, latest G2/G4 HTTP statuses, frontend state. Missing: historic uptime/error time series | **LIVE** latest runtime status; history **NOT VERIFIED** |
| Data Lineage & Governance | Full selected-record lineage and governed outcome are available | G1, G2, G4 | G1 retrieval; G2 resolve; G4 execute | Available: observation/canonical IDs, timestamps, source/provenance reference, context ID including literal `null`, ruling, eligibility, abstention, action request, G4 status/evidence IDs | **CANONICAL** (G1 identity) and **LIVE** (current G2/G4 execution) |

## Verified record fields

The audited G1 record exposed the following field groups. These are field availability facts, not a claim about a database schema.

- Identity/canonical: `observation_id`, `canonical_record_id`, `dataset_id`, `geo_id`, `contract_version`, `schema_version`.
- Source/provenance: `provenance_reference`, `capture_method`, `device_id`, raw artifact URL, SHA-256, `measurements[].provenance`.
- Time: `observed_at`, `observation_timestamp`, `timestamp`, `source_timestamp`, raw-artifact `captured_at`.
- Geography: `latitude`, `longitude`, `geo_location` (EPSG:4326), `location`; altitude and accuracy may be null/not verified.
- Quality/measurement: `observation_type`, `quality_status`, `quality_state`, `data_state`, `synthetic_state`, `measurements[]`.
- Explicitly absent in the audited record: `species`, `confidence`, altitude, GNSS accuracy, calibration status.

## Database audit result

**NOT VERIFIED.** The checked UI repository contains no server source, database client configuration, migration, database endpoint, schema API, or authenticated database access. The consumer-facing G1 API returns a document-shaped observation but does not disclose underlying table names, record counts, or query capability. Any table name or count would be invented and must not be displayed.

## Exact source additions needed for unavailable features

1. A read-only observation collection API with stable pagination/filtering by time, source, geography, observation type, and governance outcome.
2. Forest-cover measurements with area/unit, temporal period, method, confidence/quality, geographic geometry or boundary reference, and provenance.
3. Plantation, wildlife, conflict, forest-produce, and district domain records using their feature-specific fields listed above.
4. Verified district reference/boundary data or an explicit district identifier carried by observations.
5. A historical health/alert feed for trends; current G4 summary is explicitly `stateless` and returned no activities at audit time.
