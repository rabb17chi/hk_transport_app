# Storage Strategy Recommendation

## Current State Analysis

### 1. KMB Bus Routes & Station Names
- **Current**: SharedPreferences (KMBCacheService)
- **Data Size**: Large (~500+ routes, ~5000+ stops)
- **Update Frequency**: Weekly
- **Query Pattern**: Simple key-value lookups
- **Recommendation**: ✅ **Keep SharedPreferences**

**Why SharedPreferences:**
- Simple key-value storage fits the use case
- No complex queries needed (just get routes/stops by key)
- Infrequent updates (weekly cache refresh)
- Easy to clear/reset
- Lower overhead than SQLite for simple data

**When to consider Database:**
- If you need complex filtering/searching (e.g., "find all routes passing through station X")
- If you need relationships/joins between routes and stops
- If data grows significantly (>10MB)

---

### 2. CTB Bus Routes & Station Information
- **Current**: SharedPreferences (CTBCacheService) + Database (CTBDatabaseService - partially implemented)
- **Data Size**: Medium (~200+ routes, ~2000+ stops)
- **Update Frequency**: Weekly
- **Query Pattern**: Simple lookups
- **Recommendation**: ✅ **Use SharedPreferences Only**

**Why SharedPreferences:**
- Same reasoning as KMB
- Smaller dataset than KMB, so even less need for database
- Simpler to maintain
- Consistent with KMB approach

**Action**: Remove or deprecate CTBDatabaseService, use CTBCacheService only

---

### 3. MTR Data
- **Current**: Static code (hardcoded in `mtr_data.dart`)
- **Data Type**: Static reference data (lines, stations, colors)
- **Update Frequency**: Never (only changes with app updates)
- **Recommendation**: ✅ **Keep as Static Code**

**Why Static Code:**
- Reference data that rarely changes
- No need for caching or storage
- Faster access (in-memory)
- Smaller app size (no storage overhead)
- Bookmarks use SharedPreferences (perfect for user data)

**No changes needed** - current approach is optimal

---

### 4. User Settings (Language, Theme, Data Operations)
- **Current**: SharedPreferences (SettingsService)
- **Data Size**: Very small (<1KB)
- **Update Frequency**: User-driven (infrequent)
- **Query Pattern**: Simple get/set
- **Recommendation**: ✅ **Keep SharedPreferences**

**Why SharedPreferences:**
- Perfect for small key-value settings
- Native Flutter support
- Fast read/write
- No complex queries needed
- Industry standard for app settings

---

## Final Recommendation: **SharedPreferences for Everything**

### Summary Table

| Data Type | Storage Method | Reason |
|-----------|---------------|--------|
| KMB Routes/Stops | SharedPreferences | Simple lookups, infrequent updates |
| CTB Routes/Stops | SharedPreferences | Simple lookups, infrequent updates |
| MTR Data | Static Code | Reference data, never changes |
| User Settings | SharedPreferences | Small key-value pairs |
| Bookmarks | SharedPreferences | User data, simple structure |

### Benefits of This Approach:
1. **Simplicity**: One storage mechanism for all data
2. **Performance**: Fast reads/writes for simple data
3. **Maintainability**: Easier to understand and debug
4. **Storage Efficiency**: No database overhead
5. **Consistency**: Same pattern throughout the app

### When to Consider SQLite Database:
- Need complex queries (JOINs, filtering, sorting)
- Need relationships between data entities
- Data size exceeds SharedPreferences limits (~10MB)
- Need transactions or data integrity constraints
- Need full-text search capabilities

### Action Items:
1. ✅ Keep SharedPreferences for KMB (KMBCacheService)
2. ✅ Keep SharedPreferences for CTB (CTBCacheService)
3. ✅ Remove/deprecate CTBDatabaseService (not needed)
4. ✅ Remove/deprecate KMBDatabaseService (not needed)
5. ✅ Keep MTR as static code
6. ✅ Keep SharedPreferences for settings

---

## Migration Path (If Needed Later)

If you ever need to migrate to SQLite:

1. **Create migration script** to convert SharedPreferences → SQLite
2. **Update service classes** to use database instead
3. **Keep SharedPreferences as fallback** during transition
4. **Test thoroughly** before removing SharedPreferences code

But for now, **SharedPreferences is the right choice** for your use case.

