// Use import instead of require for ES Modules
import dotenv from 'dotenv';
import Airtable from 'airtable';
import { AssetCache } from "@11ty/eleventy-cache-assets";

// Initialize dotenv
dotenv.config();

// Your Airtable configuration
const airtableBaseId = 'appzmrtvPhA1zjlGL';
const airtableTable = 'Trials';
const airtableTableView = 'Grid view';

// Initialize Airtable
const base = new Airtable({ apiKey: process.env.AIRTABLE_API_KEY }).base(airtableBaseId);

// Use export default for ES Modules
export default async function () {
  // Use a unique cache key
  let asset = new AssetCache("airtable_trials_data");

  // Check if the cache is valid (e.g., for 1 day)
  if (asset.isCacheValid("1d")) {
    console.log("Serving data from the cache…");
    return asset.getCachedValue();
  }

  // If cache is not valid, fetch fresh data from Airtable
  return new Promise((resolve, reject) => {
    let allRecords = [];

    base(airtableTable)
      .select({
        view: airtableTableView
      })
      .eachPage(
        function page(records, fetchNextPage) {
          // This function will be called for each page of records.
          records.forEach(function (record) {
            // Push the fields from each record into our array
            allRecords.push(record.fields);
          });

          // To fetch the next page of records, call `fetchNextPage`.
          // If there are more records, `page` will be called again.
          // If there are no more records, `done` will be called.
          fetchNextPage();
        },
        function done(err) {
          if (err) {
            // If there's an error, reject the promise
            reject(err);
          } else {
            // If successful, save the data to the cache
            console.log(`Saving ${allRecords.length} records to cache...`);
            asset.save(allRecords, "json");
            // And resolve the promise with the data
            resolve(allRecords);
          }
        }
      );
  });
};
