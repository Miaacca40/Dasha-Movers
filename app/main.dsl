import "commonReactions/all.dsl";

context 
{
    // declare input variables here
    input phone: string;

    // declare storage variables here 
    name: string = ""; 
    policy_number: string = ""; 
    policy_read: string = "";
    policy_status: string = "";
    rating: string = "";
	date: string = "";
    feedback: string = "";
	orgn_city: string = "";
	dest_city: string = "";
	zip_code_orgn: string = "";
	movetype: string = "";
	phone_no: string = "";
    phone_no2: string = "";
	email_info: string = "";
	claim: string = "";
}

// declare external functions here 
external function check_policy(policy_number: string): string;
external function convert_policy(policy_number: string): string;

// lines 28-42 start node 
start node root 
{
    do //actions executed in this node 
    {
        #connectSafe($phone); // connecting to the phone number which is specified in index.js that it can also be in-terminal text chat
        #waitForSpeech(1000); // give the person a second to start speaking 
        #say("greeting");
		#waitForSpeech(1000);
		#sayText("May I have your Full Name Please ?");	// and greet them. Refer to phrasemap.json > "greeting"
        
		wait *; // wait for a response
    }
    transitions // specifies to which nodes the conversation goes from here 
    {
        node_2: goto node_2 on #messageHasData("name"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
    }
}

node node_2
{
    do
    {
        set $name =  #messageGetData("name")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($name);
        #say("pleased_meet", {name: $name} ); 
        wait*;
    }
	transitions // specifies to which nodes the conversation goes from here 
    {
        node_phone_no: goto phone_no on #messageHasData("phone_no"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
    }
}

node phone_no {
do
{
set $phone_no =  #messageGetData("phone_no")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($phone_no);
        #sayText("Okey i got the number" );
		#waitForSpeech(1000);
		#sayText("Do you have a secondary phone number as well? This is just in case we can't reach you at your primary number.");
		
        wait*;
}
transitions // specifies to which nodes the conversation goes from here 
    {
        node_phone_no2: goto phone_no2 on #messageHasData("phone_no2"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
		node_phone2no: goto phone_no2no on #messageHasIntent("no");
	}
}

node phone_no2 {
do
{
set $phone_no2 =  #messageGetData("phone_no2")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($phone_no2);
        #sayText("Thanks for providing info" );
		#waitForSpeech(1000);
		#sayText("Could you please provide your email address? We can send you a detailed quote and any necessary paperwork via email.");
		
        wait*;
}
transitions // specifies to which nodes the conversation goes from here 
    {
        node_email_info: goto email_info on #messageHasData("email_info"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
    
	}
}


node phone_no2no {
do
{

        #sayText("Okey one number is enough" );
		#waitForSpeech(1000);
		#sayText("Could you please provide your email address? We can send you a detailed quote and any necessary paperwork via email.");
		
        wait*;
}
transitions // specifies to which nodes the conversation goes from here 
    {
        node_email_info: goto email_info on #messageHasData("email_info"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
    
	}
}


node email_info {
do
{
set $email_info =  #messageGetData("email_info")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($email_info);
        #sayText("Great i got the email" );
		#waitForSpeech(1000);
		#sayText("Great, now let's discuss the details of your move. Could you please provide the complete address that you'll be moving from?");
		wait*;
}
transitions // specifies to which nodes the conversation goes from here 
    {
        node_phone_no2: goto phone_no2 on #messageHasData("phone_no2"); // when Dasha identifies that the user's phrase contains "name" data, as specified in the named entities section of data.json, a transfer to node node_2 happens 
    
	}
}




node movetype
{
    do
    {
        set $movetype =  #messageGetData("movetype")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($date);
        #say("move_type", {movetype: $movetype} );
		
		#sayText("Thank you for that information. Could you please tell me the city or area you're moving from? or specify your 5 digit zip code?");
	    #waitForSpeech(2000);	
	
		
        wait*;
    }
	transitions // specifies to which nodes the conversation goes from here 
    {
        yes_1: goto yes_1 on #messageHasData("origen");
		zip_code: goto zip_code on #messageHasData("zip_code");
    }
}

node yes_1 
{
do
{

set $orgn_city =  #messageGetData("origen")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($orgn_city);
       
		
		#sayText("Great, Please also specify your 5 digit zip code?");
	    #waitForSpeech(1000);	
	
		
        wait*;
}
transitions // specifies to which nodes the conversation goes from here 
    {
        zip_code: goto zip_code on #messageHasData("zip_code");
		
    }
	
	}
	
	
node zip_code 
{
do
{
set $zip_code_orgn =  #messageGetData("zip_code")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($zip_code_orgn);
       
		
		#sayText("Great, Please provide the city name or zip code for city you are planning to move?");
	    #waitForSpeech(1000);	
	
		
        wait*;
	}
	
	
	transitions // specifies to which nodes the conversation goes from here 
    {
        destination: goto destination on #messageHasData("destination");
		
    }
	
	}
	

node destination 
{
do
{

		set $dest_city =  #messageGetData("destination")[0]?.value??""; //assign variable $name with the value extracted from the user's previous statement 
        #log($dest_city);
        #sayText("Great,Please spicify a date for your move for your move?");
	    #waitForSpeech(2000);	
	    wait*;
}


}








node no_1 {
do
{
#sayText("Let me transfer you to human operator");
exit;
}

}


digression policy_1
{
    conditions {on #messageHasIntent("policy_check");}
    do 
    {
        #say("what_policy"); 
        wait*;
    }
    transitions
    {
        policy_2: goto policy_2 on #messageHasData("policy");
    }
}

node policy_1_a
{
    do 
    {
        #say("what_policy_2"); 
        wait*;
    }
    transitions
    {
        policy_2: goto policy_2 on #messageHasData("policy");
    }
}

node policy_2
{
    do 
    {
        set $policy_number = #messageGetData("policy")[0]?.value??"";
        set $policy_read = external convert_policy($policy_number);
        #log($policy_read);
        #say("confirm_policy" , {policy_read: $policy_read} );
        wait*;
    }
    transitions
    {
        yes: goto policy_3 on #messageHasIntent("yes");
        no: goto policy_1_a on #messageHasIntent("no");
    }
}

node policy_3
{
    do
    {
        set $policy_status = external check_policy($policy_number);
        #say("verification_result", {policy_status: $policy_status} );
        wait*;
    }
    transitions
    {
        yes: goto can_help on #messageHasIntent("yes");
        no: goto bye_rate on #messageHasIntent("no");
    }
}

node can_help 
{
    do 
    {
        #say("can_help");
        wait*;
    }
}

node bye_rate
{
    do
    {
        #say("bye_rate");
        wait*;
    }
    transitions
    {
        rating_evaluation: goto rating_evaluation on #messageHasData("rating"); 
    }
}

node rating_evaluation 
{
    do 
    {
        set $rating =  #messageGetData("rating")[0]?.value??""; //assign variable $rating with the value extracted from the user's previous statement 
        #log($rating);
        var rating_num = #parseInt($rating); // #messageGetData collects data as an array of strings; we convert the string to an integer in order to evaluate whether the rating is positive or negative
        if ( rating_num >=7 ) 
        {
            goto rate_positive; // note that this function refers to the transition's name, not the node name 
        }
        else
        {
            goto rate_negative;
        }
    }
    transitions
    {
        rate_positive: goto rate_positive; // you need to declare transition name and the node it refers to here
        rate_negative: goto rate_negative;
    }
}

node rate_positive
{
    do 
    {
        #sayText("Thank you for such a high rating and thank you for your time. Please call back if you have any more questions. Bye!");
        exit;
    }
}

node rate_negative
{
    do 
    {
        #say("rate_negative");
        wait*;
    }
    transitions
    {
        neg_bye: goto neg_bye on true;  // "on true" is a condition which lets Dasha know to take the action if the user utters any phrase 
    }
    onexit // specifies an action that Dasha AI should take, as it exits the node. The action must be mapped to a transition
    {
        neg_bye: do
        {
            set $feedback = #getMessageText();
            #log($feedback);
        }
    }
}

node neg_bye
{
    do
    {
        #sayText("Thank you for sahring and thank you for your time. Please call back if you have any more questions. Bye!");
        exit;
    }
}

// digressions 

digression how_are_you
{
    conditions {on #messageHasIntent("how_are_you");}
    do 
    {
        #sayText("I'm well, thank you!", repeatMode: "ignore"); 
        #repeat(); // let the app know to repeat the phrase in the node from which the digression was called, when go back to the node 
        return; // go back to the node from which we got distracted into the digression 
    }
}

digression describe_services
{
    conditions {on #messageHasIntent("what_services");}
    do 
    {
        #sayText("We offer a comprehensive range of services including packing, loading, transportation, unloading, residential and commercial moving, long-distance moving, and storage services. How can we assist you specifically?"); 
        //#repeat(); // let the app know to repeat the phrase in the node from which the digression was called, when go back to the node 
        return; // go back to the node from which we got distracted into the digression 
    }
}



digression accident_coverage
{
    conditions {on #messageHasIntent("accident_coverage");}
    do 
    {
        #sayText("This policy does have full accident coverage enabled. Anything else I can help you with today?", repeatMode: "ignore"); 
        wait*;
    }
    transitions
    {
        yes: goto can_help on #messageHasIntent("yes");
        no: goto bye_rate on #messageHasIntent("no");
    }
}

digression claim_status
{
    conditions {on #messageHasIntent("claim_status");}
    do 
    {
        // Here I'm purposefully not calling an external function but am doing the random and calculations within the body of DSL to show you how you can too. Obviously for a use case such as this you would want to call up an external function and get the data from an external service 
        var foo = #random(); 
        if (foo >= .45)
        {
            set $claim = " the claim is due to be resolved on August 31st.";
        }
        else 
        {
            set $claim = " the claim has been approved.";
        }
        #say("claim_status", {claim: $claim} ); 
        wait*;
    }
    transitions
    {
        yes: goto can_help on #messageHasIntent("yes");
        no: goto bye_rate on #messageHasIntent("no");
    }
}

digression redeem_claim
{
    conditions {on #messageHasIntent("redeem_claim");}
    do 
    {
        #say("redeem_claim"); 
        wait*;
    }
    transitions
    {
        yes: goto refund on #messageHasIntent("yes");
        no: goto can_help on #messageHasIntent("no");
    }
}


digression dont_understand {
    conditions {
        // set low priority to avoid triggering on any other transitions
        on true priority -100;
    }
    do {
        #log("digression 'dont_understand'");
        // say phrase that will no be repeated 
        //#sayText("Sorry, Can you repeat yourself", repeatMode:"ignore");
        #say("dont_understand");
		// repeat last phrase without 'repeatMode:"ignore"' option
        //#repeat();
        // return to the node where this digression was triggered
        return;
    }
}




node refund
{
    do
    {
        #sayText("Great. Refund process initiated. You should receive your money in three to five days. Anything else I can help you with?");
        wait *;
    }
    transitions
    {
        yes: goto can_help on #messageHasIntent("yes");
        no: goto bye_rate on #messageHasIntent("no");
    }
}


