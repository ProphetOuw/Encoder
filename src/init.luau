local HttpService = game:GetService("HttpService")

--
local EFW = Enum.FontWeight;
local EFS = Enum.FontStyle;
local EPWA = Enum.PathWaypointAction

local m = {}
local SupportedTypes = {
	["Color3"] = function(Encode,v)
		if Encode then
			return {
				__type = "Color3";
				R = v.R;
				G = v.G;
				B = v.B;
			}
		else
			return Color3.new(v.R,v.G,v.B)
		end
	end,
	["UDim2"] = function(Encode,v)
		if Encode then
			return {
				__type = "UDim2";
				XScale = v.X.Scale;
				XOFfset = v.X.Offset;
				YScale = v.Y.Scale;
				YOffset = v.Y.Offset;
			}
		else
			return UDim2.new(
				v.XScale,v.XOffset,v.YScale,v.YOffset
			)
		end
	end,
	["CFrame"] = function(Encode, v)
		if Encode then
			local components = { v:components() }
			return {
				__type = "CFrame";
				X = components[1];
				Y = components[2];
				Z = components[3];
				R00 = components[4];
				R01 = components[5];
				R02 = components[6];
				R10 = components[7];
				R11 = components[8];
				R12 = components[9];
				R20 = components[10];
				R21 = components[11];
				R22 = components[12];
			}
		else
			return CFrame.new(
				v.X, v.Y, v.Z,
				v.R00, v.R01, v.R02,
				v.R10, v.R11, v.R12,
				v.R20, v.R21, v.R22
			)
		end
	end,
	["Rect"] = function(Encode, v)
		if Encode then
			return {
				__type = "Rect";
				MinX = v.Min.X;
				MinY = v.Min.Y;
				MaxX = v.Max.X;
				MaxY = v.Max.Y;
			}
		else
			return Rect.new(v.MinX, v.MinY, v.MaxX, v.MaxY)
		end
	end,
	["EnumItem"] = function(Encode, v)
		if Encode then
			return {
				__type = "EnumItem";
				EnumType = tostring(v.EnumType);
				Name = v.Name;
			}
		else
			local enum = Enum[v.EnumType]
			return enum[v.Name]
		end
	end,
	["PhysicalProperties"] = function(Encode, v)
		if Encode then
			return {
				__type = "PhysicalProperties";
				Density = v.Density;
				Friction = v.Friction;
				Elasticity = v.Elasticity;
				FrictionWeight = v.FrictionWeight;
				ElasticityWeight = v.ElasticityWeight;
			}
		else
			return PhysicalProperties.new(
				v.Density, v.Friction, v.Elasticity, v.FrictionWeight, v.ElasticityWeight
			)
		end
	end,
	["Font"] = function(Encode, v)
		if Encode then
			return {
				__type = "Font";
				Family = v.Family;
				Weight = v.Weight.Name;
				Style = v.Style.Name;
			}
		else
			return Font.new(v.Family, EFW[v.Weight], EFS[v.Style])
		end
	end,
	["PathWaypoint"] = function(Encode, v)
		if Encode then
			return {
				__type = "PathWaypoint";
				Position = { X = v.Position.X, Y = v.Position.Y, Z = v.Position.Z };
				Action = v.Action.Name;
			}
		else
			return PathWaypoint.new(
				Vector3.new(v.Position.X, v.Position.Y, v.Position.Z),
				EPWA[v.Action]
			)
		end
	end,
	["Vector3"] = function(Encode,v)
		if Encode then
			return {
				__type = "Vector3";
				X = v.X,
				Y = v.Y,
				Z = v.Z
			}
		else
			return Vector3.new(
				v.X,v.Y,v.Z
			)
		end
	end,
	["Vector2"] = function(Encode, v)
		if Encode then
			return {
				__type = "Vector2";
				X = v.X,
				Y = v.Y
			}
		else
			return Vector2.new(v.X, v.Y)
		end
	end,
	["UDim"] = function(Encode, v)
		if Encode then
			return {
				__type = "UDim";
				Scale = v.Scale,
				Offset = v.Offset
			}
		else
			return UDim.new(v.Scale, v.Offset)
		end
	end;
	["ColorSequence"] = function(Encode, v)
		if Encode then
			local keypoints = {}
			for _, keypoint in ipairs(v.Keypoints) do
				table.insert(keypoints, {
					Time = keypoint.Time;
					Value = {
						R = keypoint.Value.R;
						G = keypoint.Value.G;
						B = keypoint.Value.B;
					};
				})
			end
			return {
				__type = "ColorSequence";
				Keypoints = keypoints;
			}
		else
			local keypoints = {}
			for _, kp in ipairs(v.Keypoints) do
				table.insert(keypoints, ColorSequenceKeypoint.new(
					kp.Time,
					Color3.new(kp.Value.R, kp.Value.G, kp.Value.B)
					))
			end
			return ColorSequence.new(keypoints)
		end
	end;
	
	["NumberSequence"] = function(Encode, v)
		if Encode then
			local keypoints = {}
			for _, keypoint in ipairs(v.Keypoints) do
				table.insert(keypoints, {
					Time = keypoint.Time;
					Value = keypoint.Value;
					Envelope = keypoint.Envelope;
				})
			end
			return {
				__type = "NumberSequence";
				Keypoints = keypoints;
			}
		else
			local keypoints = {}
			for _, kp in ipairs(v.Keypoints) do
				table.insert(keypoints, NumberSequenceKeypoint.new(kp.Time, kp.Value, kp.Envelope))
			end
			return NumberSequence.new(keypoints)
		end
	end,
};
function m.Decode(Str)
	if Str ~= nil and Str ~= "" then
		local data = HttpService:JSONDecode(Str);
		local function LookInside(Current)
			local New = {}
			for i,v in pairs(Current) do
				local vType = (typeof(v) == "table" and v.__type) or typeof(v);
				if vType == "table" then
					New[i] = LookInside(v);
				elseif SupportedTypes[vType] then
					New[i] = SupportedTypes[vType](false,v)
				else
					New[i] = v;
				end
			end
			return New;
		end
		local NewData = LookInside(data)
		return NewData;
	end
	return
end
function m.Encode(data)
	if data == nil then return end;
	local function LookInside(Current)
		local New = {}
		for i,v in pairs(Current) do
			local vType = typeof(v);
			if vType == "table" then
				New[i] = LookInside(v);
			elseif SupportedTypes[vType] then
				New[i] = SupportedTypes[vType](true,v)
			else
				New[i] = v;
			end
		end
		return New;
	end
	local NewData = LookInside(data)
	NewData = HttpService:JSONEncode(NewData)
	return NewData
end
export type mType = {
	Decode: (Source: string) -> {},
	Encode: (Data: {}) -> string;
}
return m:: mType;