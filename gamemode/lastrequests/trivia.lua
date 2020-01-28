-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################


JB.randomQuestions = {
	{ // Questions about the Jail Break gamemode
		{question="What does LR stand for?",answer="last request"},
		{question="Who is the person in charge of the prison?",answer="warden"},
		{question="What does KOS stand for?",answer="kill on sight"},
		{question="What does AFK stand for?",answer="away from keyboard"},
		{question="What does FRLR stand for?",answer="first reaction last reaction"},
		{question="What year was Poseidon founded? Hint: not 1999",answer="2012"},
		{question="Name the gMod gamemode in which everyone is a terrorist.",answer="TTT"},
		{question="Name the gMod gamemode in which you can watch youtube.",answer="Cinema"},
	},
	{ // Questions about internet culture, games, etc...
		{question="In video gaming, what is the name of the princess whom Mario repeatedly stops Bowser from kidnapping?",answer="Princess Peach"},
		{question="In the game ‘Mortal Kombat’, what phrase is heard when Scorpion uses his spear?",answer="Get over here"},
		{question="In video games, what colour is Pac-Man?",answer="yellow"},
		{question="‘Black Ops’ is the subtitle of which game?",answer="Call of Duty"},
		{question="Pikachu is one of the species of creatures in which series of games?",answer="Pokemon"},
		{question="Jumpman’s goal is to save the Lady from the giant ape in which 1981 arcade game?",answer="Donkey Kong"},
		{question="What is the name of the Mario franchise's first fully 3D game?",answer="Super Mario 64"},
		{question="The Covenant are fictional military alien races in which game series?",answer="Halo"},
		{question="What color is the most autistic video game hedgehog?",answer="blue"},
		{question="What's the name of the internet's most controversial imageboard forum?",answer="4chan"},
		{question="What year was Grand Theft Auto: San Andreas released?",answer="2004"},
	},
	{ // Questions about human subjects, such as history and geography 
		{question="Name a game in which two teams kick a ball around.",answer="soccer"},
		{question="Name a game in which two teams dribble a ball around.",answer="basketball"},
		{question="Name a game in which you can't move while holding the ball.",answer="netball"},
		{question="Which American state was nearest to the Soviet Union? Hint: Not attached to the mainland",answer="Alaska"},
		{question="What is converted into alcohol during brewing?",answer="Sugar"},
		{question="In which city is Hollywood?",answer="Los Angeles"},
		{question="In which city did the Twin Towers stand?",answer="New York"},
		{question="In which country would you find the Mona Lisa painting?",answer="France"},
		{question="What's the smallest state in Australia?",answer="Tasmania"},
		{question="What's the biggest state in Australia?",answer="Western Australia"},
		{question="What's the capital city of Australia?",answer="Canberra"},
		{question="What does SOS stand for?",answer="Save our souls"},
		{question="What do you call a group of crows?",answer="Murder"},
		{question="What is the nearest galaxy to our own?",answer="Andromeda"},
		{question="What is the nearest planet to our sun?",answer="Mercury"},
		{question="How many legs has a spider got?",answer="8"},
		{question="In which 1979 film was the spaceship called Nostromo? Hint: Facehuggers, horror film ",answer="Alien"},
		{question="What year did the Vietnamese war start?",answer="1955"},
		{question="In Roman mythology, Neptune is the equivalent to which Greek god?",answer="Poseidon"},
		{question="How many cents does a 30c cone at McDonalds cost?",answer="30"},
		{question="Ayers Rock in Australia is also known as what?",answer="Uluru"}
		{question="How many horns did Triceratops have?",answer="3"}

	},
	"mathproblem"
};

local question,answer;

_RTN_RUNSTRING_JB_LR_TRIVIA_QUESTION = 0;

local winner_found = false;
local LR = JB.CLASS_LR();
LR:SetName("Trivia");
LR:SetDescription("After the countdown, a random question about a random subject will be asked. The first person to answer this question correctly in chat will win the last request, the loser will be killed.");
LR:SetStartCallback(function(prisoner,guard)
	local subject = JB.randomQuestions[math.random(1,#JB.randomQuestions)];
	
	if type("subject") == "string" and subject == "mathproblem" then
		local operationsFirst = {" + "," - "};
		local operationsSecond = {" * "};

		question=tostring(math.random(1,10));

		local typ = math.random(1,4);
		if typ == 1 or typ == 2 then
			question=question..table.Random(operationsFirst)..tostring(math.random(1,10));
		end

		local div = 0;

		if typ == 2 or typ == 3 or typ == 4 then
			div = math.random(1,10);
			question=question..table.Random(operationsSecond)..(typ == 4 and "( " or "")..tostring(div);
		end

		if typ == 3 then
			question=question..table.Random(operationsSecond)..tostring(math.random(1,10))
		elseif typ == 4 then
			local sec = math.random(-10,10);
			if div-sec == 0 then
				sec = sec+math.random(1,5);
			end
			question=question..table.Random(operationsFirst)..sec.." )";
		end

		RunString("_RTN_RUNSTRING_JB_LR_TRIVIA_QUESTION = "..question..";");
		answer = _RTN_RUNSTRING_JB_LR_TRIVIA_QUESTION;
		question=question.." = "
		
	elseif type(subject) == "table" then
		local rnd = table.Random(subject);
		question = rnd.question; // TODO: add more questions
		answer = rnd.answer;
	end

	winner_found = false;

	net.Start("JB.LR.Trivia.SendQuestion");
	net.WriteString(question);
	net.Broadcast();
end) 

LR:SetSetupCallback(function(prisoner,guard)
	net.Start("JB.LR.Trivia.SendPrepare");
	net.WriteEntity(prisoner);
	net.WriteEntity(guard);
	net.Broadcast();

	return false; // don't halt setup
end)

LR:SetIcon(Material("icon16/rosette.png"))

local id = LR();

if SERVER then
	util.AddNetworkString("JB.LR.Trivia.SendQuestion");
	util.AddNetworkString("JB.LR.Trivia.SendPrepare");
	util.AddNetworkString("JB.LR.Trivia.SendWinner");

	hook.Add( "PlayerSay", "JB.PlayerSay.LR.Trivia", function( ply, text, team )
		if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,ply) and string.find(string.lower(text),string.lower(answer)) and not winner_found then
			timer.Simple(0,function()
				net.Start("JB.LR.Trivia.SendWinner");
				net.WriteEntity(ply);
				net.Broadcast();
			end);

			for k,v in ipairs(JB.LastRequestPlayers)do
				if IsValid(v) and v != ply then
					v:Kill();
				end
			end
			winner_found = true;
		end
	end )
elseif CLIENT then
	hook.Add("PlayerBindPress", "JB.PlayerBindPress.LR.TriviaNoSayBindsFuckYou", function(pl, bind, pressed) // Not the safest way, but it requires the least amount of touching code outside of this file (without using nasty hacky methods)
		if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,pl) and string.find( bind,"say" ) then
			return true;
		end
	end)

	net.Receive("JB.LR.Trivia.SendPrepare",function()
		local guard,prisoner = net.ReadEntity(),net.ReadEntity();

		if not JB.Util.isValid(guard,prisoner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": Hello ", guard, JB.Color.white, " and ", prisoner, JB.Color.white, ", prepare to give your answer via chat." );
		timer.Simple(2,function()
			chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": The first person to answer correctly will win this game of Trivia." );
		end);
	end);
	net.Receive("JB.LR.Trivia.SendQuestion",function()
		local question = net.ReadString() or "ERROR";
		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": "..question );
	end);
	net.Receive("JB.LR.Trivia.SendWinner",function()
		local winner = net.ReadEntity();

		if not IsValid(winner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": That is correct! ", winner, JB.Color.white, " wins." );
	end);	
end