local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local PhantomForcesWindow = Library:NewWindow("Goodboy99💩")

local AutoParry = PhantomForcesWindow:NewSection("Main/Menu")

AutoParry:CreateButton("Auto Parry", function()local Debug = false -- Set this to true if you want my debug output.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9) -- A second argument in waitforchild what could it mean?
local Balls = workspace:WaitForChild("Balls", 9e9)

-- Anticheat bypass
loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)()

-- Functions

local function print(...) -- Debug print.
    if Debug then
        warn(...)
    end
end

local function VerifyBall(Ball) -- Returns nil if the ball isn't a valid projectile; true if it's the right ball.
    if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then
        return true
    end
end

local function IsTarget() -- Returns true if we are the current target.
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

local function Parry() -- Parries.
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end

-- The actual code

Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then
        return
    end
    
    print(`Ball Spawned: {Ball}`)
    
    local OldPosition = Ball.Position
    local OldTick = tick()
    
    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then -- No need to do the math if we're not being attacked.
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude -- Fix for .Velocity not working. Yes I got the lowest possible grade in accuplacer math.
            
            print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)
        
            if (Distance / Velocity) <= 10 then -- Sorry for the magic number. This just works. No, you don't get a slider for this because it's 2am.
                Parry()
            end
        end
        
        if (tick() - OldTick >= 1/60) then -- Don't want it to update too quickly because my velocity implementation is aids. Yes, I tried Ball.Velocity. No, it didn't work.
            OldTick = tick()
            OldPosition = Ball.Position
        end
    end)
end)
end)


AutoParry:CreateButton("Auto Parry2", function()ToggleKey = ToggleKey or Enum.KeyCode.Z;

local Cloneref = cloneref or function(Object)return Object end;

local StatsService = Cloneref(game:GetService("Stats"));
local UserInputService = Cloneref(game:GetService("UserInputService"));
local ReplicatedStorage = Cloneref(game:GetService("ReplicatedStorage"));
local Players = Cloneref(game:GetService("Players"));
local Player = Players.LocalPlayer;

local Running = true;
local Saved = {
	LastTick = os.clock();
	LastBallPosition = nil;
	AttemptedParry = false,
};

local function GetBall()
	local RealBall, OtherBall = nil, nil;
	for Int, Object in pairs(workspace.Balls:GetChildren()) do
		if Object:GetAttribute("realBall") == true then
			RealBall = Object;
		else
			OtherBall = Object;
		end;
	end;
	return RealBall, OtherBall;
end;
local function AttemptParry(OtherBall)
	ReplicatedStorage.Remotes.ParryAttempt:FireServer(1.5, OtherBall.CFrame, (function()
		local Results = {};
		for Int, Character in pairs(workspace.Alive:GetChildren()) do
			Results[Character.Name] = Character.HumanoidRootPart.Position;
		end;
		return Results;
	end)(), {math.random(100, 999), math.random(100, 999)});
end;

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed == false then
		if Input.KeyCode == ToggleKey then
			Running = not Running;
		end;
	end;
end);

while task.wait() do
	if Running == true then
		local RealBall, OtherBall = GetBall();
		if RealBall ~= nil and OtherBall ~= nil then
			if Saved.LastBallPosition ~= nil then
				if RealBall:GetAttribute("target") == Player.Name then
					local DeltaT = os.clock()-Saved.LastTick;
					local VelocityX = (OtherBall.Position.X-Saved.LastBallPosition.X)/DeltaT;
					local VelocityY = (OtherBall.Position.Y-Saved.LastBallPosition.Y)/DeltaT;
					local VelocityZ = (OtherBall.Position.Z-Saved.LastBallPosition.Z)/DeltaT;
					local VelocityMagnitude = math.sqrt(VelocityX^2+VelocityY^2+VelocityZ^2);

					local ServerPing = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue();
					local DistanceToPlayer = (Player.Character.HumanoidRootPart.Position-OtherBall.Position).Magnitude;
					local EstimatedTimeToReachPlayer = (ServerPing/VelocityMagnitude)/(ServerPing/DistanceToPlayer);
					local TimeToParry = 0.2*(VelocityMagnitude/DistanceToPlayer);

					print(EstimatedTimeToReachPlayer, "<=", TimeToParry);

					if tostring(EstimatedTimeToReachPlayer) ~= "inf" and TimeToParry < 10 then
						if EstimatedTimeToReachPlayer <= TimeToParry then
							if Saved.AttemptedParry == false then
								warn("--firing");
								AttemptParry(OtherBall);
								Saved.AttemptedParry = true;
							else
								warn("--attempted");
							end;
						else
							Saved.AttemptedParry = false;
						end;
					end;
				else
					Saved.AttemptedParry = false;
				end;
			end;
			Saved.LastBallPosition = OtherBall.Position;
		end;
	end;
	Saved.LastTick = os.clock();
end;
end)


AutoParry:CreateButton("Auto Parry3", function()getgenv().Paws = {
        ["AutoParry"] = true,
        ["PingBased"] = true,
        ["PingBasedOffset"] = 0,
        ["DistanceToParry"] = 0.5,
        ["BallSpeedCheck"] = true,
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ReplicatedPaw = game:GetService("ReplicatedStorage")

local Paws = ReplicatedPaw:WaitForChild("Remotes", 9e9)
local PawsBalls = workspace:WaitForChild("Balls", 9e9)
local PawsTable = getgenv().Paws

local function IsTheTarget()
        return Player.Character:FindFirstChild("Highlight")
end

local function FindBall()
    local RealBall
    for i, v in pairs(PawsBalls:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            RealBall = v
        end
    end
    return RealBall
end

game:GetService("RunService").PreRender:connect(function()
        if not FindBall() then 
                return
        end
        local Ball = FindBall()
        
        local BallPosition = Ball.Position
        
        local BallVelocity = Ball.AssemblyLinearVelocity.Magnitude
        
        local Distance = Player:DistanceFromCharacter(BallPosition)
        
        local Ping = BallVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
        
        if PawsTable.PingBased then
        Distance -= Ping + PawsTable.PingBasedOffset
        end
        
        if PawsTable.BallSpeedCheck and BallVelocity == 0 then return
        end
        
        if (Distance / BallVelocity) <= PawsTable.DistanceToParry and IsTheTarget() and PawsTable.AutoParry then
               Paws:WaitForChild("ParryButtonPress"):Fire()
           end
end)
end)



AutoParry:CreateButton("Auto Parry4", function()local Debug = false -- Set this to true if you want my debug output.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9) -- A second argument in waitforchild what could it mean?
local Balls = workspace:WaitForChild("Balls", 9e9)

-- Anticheat bypass
loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)()

-- Functions

local function print(...) -- Debug print.
    if Debug then
        warn(...)
    end
end

local function VerifyBall(Ball) -- Returns nil if the ball isn't a valid projectile; true if it's the right ball.
    if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then
        return true
    end
end

local function IsTarget() -- Returns true if we are the current target.
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

local function Parry() -- Parries.
    Remotes:WaitForChild("ParryButtonPress"):Fire()
end

-- The actual code

Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) then
        return
    end
    
    print(`Ball Spawned: {Ball}`)
    
    local OldPosition = Ball.Position
    local OldTick = tick()
    
    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then -- No need to do the math if we're not being attacked.
            local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
            local Velocity = (OldPosition - Ball.Position).Magnitude -- Fix for .Velocity not working. Yes I got the lowest possible grade in accuplacer math.
            
            print(`Distance: {Distance}\nVelocity: {Velocity}\nTime: {Distance / Velocity}`)
        
            if (Distance / Velocity) <= 10 then -- Sorry for the magic number. This just works. No, you don't get a slider for this because it's 2am.
                Parry()
            end
        end
        
        if (tick() - OldTick >= 1/60) then -- Don't want it to update too quickly because my velocity implementation is aids. Yes, I tried Ball.Velocity. No, it didn't work.
            OldTick = tick()
            OldPosition = Ball.Position
        end
    end)
end)
end)


AutoParry:CreateButton("Auto Parry5", function()getgenv().god = true
while getgenv().god and task.wait() do
    for _,ball in next, workspace.Balls:GetChildren() do
        if ball then
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position, ball.Position)
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Highlight") then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0, 0, (ball.Velocity).Magnitude * -0.5)
                    game:GetService("ReplicatedStorage").Remotes.ParryButtonPress:Fire()
                end
            end
        end
    end
end 
end)