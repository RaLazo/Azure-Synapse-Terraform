import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import * as fs from "fs";
import * as path from "path";
const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('HTTP trigger function processed a request.');
    // Read an HTML file in the directory and return the contents
        
    if (req.query.data) {
        context.res = {
            headers: {"Content-Type": "application/json"},
            body: {
                wheater: [12, 19, 3, 5, 2, 3],
                wind: [1, 2, 5, 10, 6, 10]                
            }
        };
    }else{
        const htmlContent = fs.readFileSync(path.resolve(__dirname, 'index.html'));
        context.res = {
            headers: {"Content-Type": "text/html"},
            body: htmlContent
        };
    }
};

export default httpTrigger;