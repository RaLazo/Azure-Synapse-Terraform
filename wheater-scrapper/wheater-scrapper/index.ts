import { AzureFunction, Context } from "@azure/functions"
import axios from "axios";

const timerTrigger: AzureFunction = async function (context: Context, myTimer: any): Promise<void> {
    var timeStamp = new Date().toISOString();
    // Check if timer is on Time
    if (myTimer.isPastDue)
    {
        context.log('Timer function is running late!');
    }
    context.log('Timer trigger function ran!', timeStamp);
    try{
        const wheaterData = await axios.get("https://api.open-meteo.com/v1/forecast?latitude=48.17&longitude=16.42&current_weather=true")
        const event = {
            "specversion" : "1.0",
            "type" : "com.example.someevent",
            "source" : "/mycontext",
            "subject": null,
            "id" : "C234-1234-1234",
            "time" : "2018-04-05T17:31:00Z",
            "comexampleextension1" : "value",
            "comexampleothervalue" : 5,
            "datacontenttype" : "application/json",
            "data" : {
                countryCode: "AT",
                location: "Vienna",
                ...wheaterData.data
            }
        }
        context.bindings.outputEventHubMessage = event;
        context.log("Wheater Function run successfully");
    }catch(err){
        context.log("Wheater Function run into an issue")
        context.log(err)
    }
};

export default timerTrigger;
