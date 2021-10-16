## Django Based API End Points :

### ADKit: Smartphone Based Artificial Intelligence Enabled Portable Low-cost Anemia Detection Kit based on Observation of Nail and Palm Pallor
### Under MEITY

#### Status : Ongoing


#### API Contract
```

Type  POST

Endpoint /api/processVideo

Body 
{
“URL”: “<URL OF THE VIDEO>”,
“AGE”: “<User Age>”,
“GENDER” : “<0 for male, 1 for female>”
}

Response 
{
val: “<Haemoglobin Value>” 
}
```

#### Implemented Job Scheduler and Message Queue
- Celery
- Rabbit MQ

