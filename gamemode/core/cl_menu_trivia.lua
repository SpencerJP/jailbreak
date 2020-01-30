cLabel = {}; -- We need a table to define and store our custom control in.
cLabel.Text = nil; -- The text we are displaying
cLabel.TextAlign = nil; -- How to align the text; 0 means left, 1 means center.
cLabel.Font = nil;
cLabel.Color = nil;
 
-- Initialize function; this is called when the object is created
function cLabel:Init()
  -- Inside these functions, we use self.(property), because we are referencing 
  self.Text =""; -- 
  self.TextAlign = 0; -- unless otherwise specified, we will want to align left.
  self.Font = "ChatFont"; -- This is our default font
  self.Color = Color( 255,255,0,255 );
end
function cLabel:Paint()
  -- This is where we do all the painting.
  return true; -- Returning true tells the renderer that it doesn't need to call the Paint() function of the object that we derived this object from.
end
 
-- Properties
-- Here, we are basically making it so that instead of accessing the variables directly,
-- we are making it so that we can check to make sure that the value is valid for what
-- we are setting. Also, if you need to use it with a timer, you can use these instead of
-- creating other functions.
function cLabel:SetText( text )
end
function cLabel:GetText()
end
 
function cLabel:SetAlign( align )
end
function cLabel:GetAlign()
end
 
function cLabel:SetFont( font )
end
function cLabel:GetFont()
end
 
function cLabel:SetColor( color )
end
function cLabel:GetColor()
end
 
vgui.Register( "cLabel", cLabel, "Panel" );

function cLabel:SetText( text )
  self.Text = text; -- Make sure that you're using self!
end
function cLabel:GetText()
  return self.Text;
end
 
function cLabel:SetAlign( align )
  if ( align == 0 || align == 1 ) then
    self.TextAlign = align;
  else
    Msg( "Invalid align [" .. align .. "] passed to control!\n" );
  end
end
function cLabel:GetAlign()
  return self.TextAlign;
end
 
function cLabel:SetFont( font )
  self.Font = font;
end
function cLabel:GetFont()
  return self.Font;
end
 
function cLabel:SetColor( color )
  if ( string.lower( type( color ) ) != "color" ) then
    Msg( "Invalid color passed to label!\n" );
    return false;
  else
    self.Color = color;
  end
end
function cLabel:GetColor()
  return self.Color;
end
timer.Simple(1, function() JB:LoadTriviaClient() end)


function JB:MENU_TRIVIA()
	local jbTriviaAccess = "ulx jbtrivia"
	if not ULib.ucl.query( LocalPlayer(), jbTriviaAccess ) then return end
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos(ScrW()/2-(ScrW() * 0.258/2),ScrH()/2-(ScrH() * 0.477/2))
	DermaPanel:SetSize( 500, 550 )
	DermaPanel:SetTitle( "Splerge's Trivia Menu" )
	DermaPanel:ShowCloseButton( true )
	DermaPanel:SetVisible( true )
	DermaPanel:MakePopup()

	cLabelTest = vgui.Create( "cLabel", DermaPanel );
	cLabelTest:SetSize( 90, 25 );
	cLabelTest:SetPos( 13, 27 );
	cLabelTest:SetText( "Question" );
	cLabelTest:SetAlign( 1 );
 
	local DermaText = vgui.Create( "DTextEntry", DermaPanel )
	DermaText:SetPos( 20,45 )
	DermaText:SetTall( 20 )
	DermaText:SetWide( 450 )
	DermaText:SetEnterAllowed( false )

	cLabelTest = vgui.Create( "cLabel", DermaPanel );
	cLabelTest:SetSize( 90, 25 );
	cLabelTest:SetPos( 12, 67 );
	cLabelTest:SetText( "Answer" );
	cLabelTest:SetAlign( 1 );

	local DermaText2 = vgui.Create( "DTextEntry", DermaPanel )
	DermaText2:SetPos( 20,85 )
	DermaText2:SetTall( 20 )
	DermaText2:SetWide( 80 )
	DermaText2:SetEnterAllowed( true )

	local DermaListView = vgui.Create("DListView")
	DermaListView:SetParent(DermaPanel)
	DermaListView:SetPos(25, 150)
	DermaListView:SetSize(450, 325)
	DermaListView:SetMultiSelect(false)
	DermaListView:AddColumn("Questions")
	DermaListView:AddColumn("Answers")
	
	local triviatable = JB.randomQuestions[1]
 
	for i=1,#triviatable do
		local question = triviatable[i].question
		local answer = triviatable[i].answer
		DermaListView:AddLine(question,answer)
	end
	local DermaButton2 = vgui.Create( "DButton" )
	DermaButton2:SetParent( DermaPanel )
	DermaButton2:SetText( "Remove Selected From List" )
	DermaButton2:SetPos( 260, 115 )
	DermaButton2:SetSize( 200, 30 )				
	DermaButton2.DoClick = function()
		//if not DermaListView:GetSelectedLine() then return end
		//local tabletoinsert = {question=DermaText:GetValue(),answer=DermaText2:GetValue()}
		if not DermaListView:GetSelectedLine() then return end
		print("Removing the following:")
		PrintTable(table.remove(JB.randomQuestions[1], DermaListView:GetSelectedLine()))
		DermaListView:RemoveLine(DermaListView:GetSelectedLine())
	end

	local DermaButtonSave = vgui.Create( "DButton" )
	DermaButtonSave:SetParent( DermaPanel )
	DermaButtonSave:SetText( "Save" )
	DermaButtonSave:SetPos( 260, 480 )
	DermaButtonSave:SetSize( 200, 30 )				
	DermaButtonSave.DoClick = function()
		net.Start("JB.SaveTrivia")
		net.WriteTable(JB.randomQuestions[1])
		net.SendToServer()
		DermaPanel:SetTitle( "Success!" )
		LocalPlayer():PrintMessage( HUD_PRINTTALK, "Success!")
		timer.Simple(1, function() DermaPanel:SetTitle( "Splerge's Trivia Menu" ) end)
	end
	local DermaButtonReload = vgui.Create( "DButton" )
	DermaButtonReload:SetParent( DermaPanel )
	DermaButtonReload:SetText( "Reload" )
	DermaButtonReload:SetPos( 30, 480 )
	DermaButtonReload:SetSize( 200, 30 )				
	DermaButtonReload.DoClick = function()
		JB:LoadTriviaClient()
		timer.Simple(0.2, function() 
		triviatable = JB.randomQuestions[1]
			DermaListView:Clear()
 
			for i=1,#JB.randomQuestions[1] do
				local question = triviatable[i].question
				local answer = triviatable[i].answer
				DermaListView:AddLine(question,answer)
			end
		end)
	end
	local DermaButton = vgui.Create( "DButton" )
	DermaButton:SetParent( DermaPanel )
	DermaButton:SetText( "Add Trivia Question" )
	DermaButton:SetPos( 30, 115 )
	DermaButton:SetSize( 200, 30 )				
	DermaButton.DoClick = function()
		if DermaText:GetValue() == "" or DermaText2:GetValue() == "" then return end
		local tabletoinsert = {question=DermaText:GetValue(),answer=DermaText2:GetValue()}
		table.insert(JB.randomQuestions[1], tabletoinsert )
		DermaListView:AddLine(DermaText:GetValue(),DermaText2:GetValue())
	end
end

net.Receive('JB.TriviaMenu', function()
		JB:MENU_TRIVIA()
end)	

function cLabel:Paint()
  -- This is where we do all the painting.
  if ( self.TextAlign == 1 ) then
    x = self:GetWide() / 2;
  else
    x = 0;
  end
 
  -- Arguments:  Text,  Font,  X Pos,  Y Pos,  Color,  Text Alignment
  draw.DrawText( self.Text, self.Font, x, 0, self.Color, self.TextAlign );
  return true;
end
