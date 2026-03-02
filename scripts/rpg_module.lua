local CHOICE_GENERATION_INSTRUCTION = [[
## Assistant Guidance: Choice Generation
- Generate 3~4 choices related to the "Skill Check" in the following format:

[Skill Name|Action Description, an action appropriate for the skill|Risk and Difficulty. A difficulty modifier will be determined based on this level. High risk, high return; low risk, low return.|Success: Effects of a successful action—vary them by difficulty and circumstances. Whether the enemy is defeated or not. Follow-up checks apply only in combat.|Difficulty Modifier:Easy/Normal/Hard/Very Hard]
...
...
...


- Example, combat situation:

[Melee|Exchange attack and defence with the enemy, maintaining the situation.|Standard approach. Engage the enemy conventionally. Depending on {{user}}'s skill, an advantageous position can be gained.|Success: Combat continues and remains evenly matched. Generate the follow-up 'Combat Skill Checks'.|Difficulty Modifier:Normal]
[Melee|Instead of dodging the attack, counterattack with a deadly blow.|Risky, but can inflict a fatal wound on the enemy.|Success: Land a critical counterattack. Inflict a critical hit on the opponent. 
Conclude the combat.|Difficulty Modifier:Very Hard]
[Athletics|Take a large step to move out of the attack's range.|Lose the opportunity to attack and may remain on the defensive.|Success: Dodge the attack, lose attack opportunity, generate the Skill Checks from a defensive position. Generate the follow-up 'Combat Skill Checks'.|Difficulty Modifier:Easy]
[Stealth|Create a distraction and withdraw from combat.|There is some risk, but a safe retreat is possible. Generate the follow-up 'Escape Skill Checks'.|Success: Safely retreat from combat.|Difficulty Modifier:Hard]


- Example, non-combat situation:

[Survival|Search the hut for any signs that someone has stayed or lived here.|The cabin is messy and dark. Finding something out of the ordinary will not be easy.|Success: Immediately discover a significant clue.|Difficulty Modifier:Hard]
[Athletics|Lift the pile of collapsed materials to check underneath.|Might find something under the debris, but there is a risk of an accident.|Success: Able to lift the debris and check underneath, It is not conclusive.|Difficulty Modifier:Easy]
[Scholarship|Use knowledge to see if there's anything to be found.|Examine inscriptions, scraps of parchment, signs of lifestyle, tracks—anything.|Success: Find something using {{user}}'s knowledge.|Difficulty Modifier:Normal]


- Perspective: Only from {{user}}

## Assistant Guidance: Skill List
- Each skill has areas it covers and areas it does not. Keep this in mind when generating choices.

- Melee
  - Skills used only during combat. Cannot be used in non-combat situations.
  - Covers: Close-quarters combat; melee fighting; attacking; defending; dodging (maintaining engagement distance);
  - Does not cover: Throwing; ranged combat; scouting; surprise attacks; stealth.

- Marksmanship
  - Skills used only during combat. Cannot be used in non-combat situations.
  - Covers: Ranged combat; archery; throwing; projectile weapons.
  - Does not cover: Melee combat; dodging; defending.

- Athletics
  - Covers: Physicality; body utilization; strength; dodging (large movement dodge).
  - Does not cover: Scouting; Searching; Outlook; tracking; stealth.

- Stealth
  - Covers: Assassination; stealth attacks; attacking from a blind spot; non-lethal stealth takedowns; ambushes; infiltration; theft; escaping.
  - Does not cover: Scouting; Searching; Outlook; tracking; dodging.

- Craftsmanship
  - Covers: Crafting; repairing; upgrading; creating; maintenance.
  - Does not cover: Throwing; carrying.

- Speech
  - Covers: Social interaction; persuasion; deception; intimidation; negotiation.
  - Does not cover: Command; combat.

- Scholarship
  - Covers: Academics; alchemy; medicine; theology; logic; reading and writing.
  - Does not cover: Repairing; scouting; stealth; combat.
  
## Assistant Guidance: Companion Skill & Choices
- If {{user}} is currently accompanied by a companion, choices related to the companion can be generated. 
- Generate companion skills only when a companion is currently present.

- Format:

[Companion Name|Action Description, an action appropriate for the skill|Risk and Difficulty.|Success: Success effect.|Difficulty Modifier:Easy/Normal/Hard/Very Hard]
...


- Example:

[Ingrid|Take cover behind Ingrid to avoid the goblins' attacks and assist her.|Considering Ingrid's combat prowess, {{user}} can be reliably protected|Success: Successfully block the goblins' attacks, as there was no decisive victory, generate follow-up Skill Check.|Difficulty Modifier:Easy]
...


- When requesting or instructing a companion, their name must be entered in the Skill Name field
  - Good Example: [Ingrid|Take cover behind Ingrid to avoid the goblins' attacks and assist her.|Considering Ingrid's combat prowess, {{user}} can be reliably protected|Success: Successfully block the goblins' attacks, as there was no decisive victory, generate follow-up Skill Check.|Difficulty Modifier:Easy]
  - Bad Example: [Melee|Take cover behind Ingrid to avoid the goblins' attacks and assist her.|Considering Ingrid's combat prowess, {{user}} can be reliably protected|Success: Successfully block the goblins' attacks, as there was no decisive victory, generate follow-up Skill Check.|Difficulty Modifier:Easy]

{{OwnedPerksDescription}}

{{ChoiceLanguageInstruction}}

## Mandatory Instructions
- When generating choices, present skills that are appropriate to the situation rather than listing various skills. For example, in a situation that involves tracking something, focus on Survival not  Athletics or Stealth.
- Choices must be generated only from {{user}}'s perspective.
- Include at least one Easy difficulty choice.
- **Follow-up checks apply only in combat.** In combat situations, read the context of the chatlog and decide whether to continue combat skill checks or conclude them.
- Present plausible and realistic choices that match the current situation.
- Write "Description," "Risk and Difficulty," and "Success" in the language of the current RP.]]

local KOREAN_CHOICE_INSTRUCTION_CONTENT = [[
## Language Instruction
The current language is Korean. Generate the content for 'Action Description', 'Risk and Difficulty', and 'Success' in Korean. 'Skill Name' and 'Difficulty Modifier' MUST remain in English.

Example:


[Melee|위험을 감수하며 신속하고 치명적인 반격을 가합니다.|위험 부담이 큰 행동이지만, 상대의 허를 찔러 치명타를 입힐 수 있습니다. 전투를 마무리합니다.|Success: 치명적인 반격에 성공합니다. 적을 곧바로 쓰러트립니다.|Difficulty Modifier:Hard]
[Athletics|최대한 공격 범위에서 벗어나기 위해 크게 스탭을 밟습니다.|안전한 선택지이지만 공격 기회를 잃고 수세에 몰릴 수 있습니다. 적의 공격에 대응하는 '스킬 체크'가 생성됩니다.|Success: 공격을 회피하지만, 공격 기회를 잃습니다|Difficulty Modifier:Easy]
...
...


Important: 한국어로 선택지를 생성할 때 현실적인 분위기를 유지하십시오. 아니메스러운 전투, 메리 수, 과장을 자제하십시오]]

local PERSONA_DESCRIPTION_INSTRUCTION_CONTENT = [[
--- User Description Start ---
{{personaDescription}}
--- User Description End ---
]]

-- =============================================
-- 유틸리티 및 알림 관리
-- =============================================

local session_notifications_manager = {}

function addNotification(triggerId, message)
    if not session_notifications_manager[triggerId] then
        session_notifications_manager[triggerId] = {}
    end
    table.insert(session_notifications_manager[triggerId], message)
end

function recordTemporaryChange(triggerId, key, value)
    local sourceIndex = getChatLength(triggerId) - 1

    local delta = getState(triggerId, "temporary_state_delta") or {}

    -- 인덱스가 변경되었을 때만 델타를 초기화
    if delta.sourceIndex ~= sourceIndex then
        delta = {
            data = {},
            sourceIndex = sourceIndex
        }
    end

    delta.data[key] = value
    setState(triggerId, "temporary_state_delta", delta)
    print(string.format("Recorded temporary change: %s = %s at source index %d", key, tostring(value), sourceIndex))
end

-- '%' 문자를 'percent'라는 단어로 안전하게 교체
local function PerscentReplace(originalString, placeholder, replacementValue)
    if type(replacementValue) ~= "string" then
        return originalString
    end
    local sanitizedValue = replacementValue:gsub("%%", "percent")
    return originalString:gsub(placeholder, sanitizedValue)
end

-- =======================================================
-- RPG 시스템 데이터 테이블
-- =======================================================

local skills = {
    "Melee", "Marksmanship", "Athletics", "Defense", 
    "Stealth", "Craftsmanship", "Scholarship", "Speech", "Survival"
}

local AUTO_EXP_VALUES = {
    ["easy"] = 5,
    ["normal"] = 10,
    ["hard"] = 25,
    ["very hard"] = 30
}

function getDifficultyFromDC(dc)
    if dc >= 19 then return "very hard"
    elseif dc >= 15 then return "hard"
    elseif dc >= 8 then return "normal"
    else return "easy" end
end

local skillLevelThresholds = {
    { points = 7, name = "Mythic" },
    { points = 6, name = "Legendary" },
    { points = 5, name = "Master" },
    { points = 4, name = "Expert" },
    { points = 3, name = "Proficient" },
    { points = 2, name = "Experienced" },
    { points = 1, name = "Novice" },
    { points = 0, name = "Inexperienced" }
}

function getSkillLevelNameFromPoints(points)
    for _, data in ipairs(skillLevelThresholds) do
        if points >= data.points then
            return data.name
        end
    end
    return "Inexperienced"
end

local levelUpTable = {
    { level = 2,  expRequired = 125,  pointsGained = 1, perkPointsGained = 1 },
    { level = 3,  expRequired = 175,  pointsGained = 2, perkPointsGained = 2 },
    { level = 4,  expRequired = 250,  pointsGained = 1, perkPointsGained = 1 }, 
    { level = 5,  expRequired = 350,  pointsGained = 1, perkPointsGained = 1 }, 
    { level = 6,  expRequired = 475,  pointsGained = 2, perkPointsGained = 2 }, 
    { level = 7,  expRequired = 625,  pointsGained = 1, perkPointsGained = 1 },
    { level = 8,  expRequired = 800,  pointsGained = 1, perkPointsGained = 1 },
    { level = 9,  expRequired = 1000, pointsGained = 2, perkPointsGained = 2 },
    { level = 10, expRequired = 1225, pointsGained = 1, perkPointsGained = 1 },
    { level = 11, expRequired = 1475, pointsGained = 1, perkPointsGained = 1 },
    { level = 12, expRequired = 1750, pointsGained = 2, perkPointsGained = 2 },
    { level = 13, expRequired = 2050, pointsGained = 1, perkPointsGained = 1 }, 
    { level = 14, expRequired = 2375, pointsGained = 1, perkPointsGained = 1 }, 
    { level = 15, expRequired = 2725, pointsGained = 2, perkPointsGained = 2 },
    { level = 16, expRequired = 3100, pointsGained = 1, perkPointsGained = 1 }, 
    { level = 17, expRequired = 3500, pointsGained = 1, perkPointsGained = 1 }, 
    { level = 18, expRequired = 3925, pointsGained = 2, perkPointsGained = 1 },
    { level = 19, expRequired = 4375, pointsGained = 1, perkPointsGained = 2 },
    { level = 20, expRequired = 4850, pointsGained = 2, perkPointsGained = 2 },
}

local MAX_LEVEL = 20

local skillPointBonusTable = {
    { points = 6, bonus = 6 },
    { points = 5,  bonus = 5 },
    { points = 4,  bonus = 4 },
    { points = 3,  bonus = 3 },
    { points = 2,  bonus = 2 },
    { points = 1,  bonus = 1 },
    { points = 0,  bonus = 0 }
}

local difficultyRanges = {
    ["easy"]      = { min = 1,  max = 7 },
    ["normal"]    = { min = 8, max = 14 },
    ["hard"]      = { min = 15, max = 18 },
    ["very hard"] = { min = 19, max = 23 }
}

-- =============================================
-- 퍽 테이블 (Perks)
-- =============================================
local perks = {
    -- [Character Perks]
    ["No_Time_to_Spare"] = {
        cost = 1, requirements = { level = 3 }
    },
    ["Lucky_Bastard"] = {
        cost = 1, requirements = { level = 6 }
    },
    ["Beloved"] = {
        cost = 1, requirements = { level = 6 }
    },
    ["Lucky_Coin"] = {
        cost = 1, requirements = { level = 6 }
    },
    ["Preparation"] = {
        cost = 1, requirements = { level = 6 }
    },
["Adrenaline_Rush"] = {
cost = 1, requirements = { level = 9 }
},
    ["Rabbit_Foot"] = {
        cost = 1, requirements = { level = 9 }
    },
    ["All_or_Nothing"] = {
        cost = 1, requirements = { level = 3 }
    },

    -- [Melee Perks]
    ["Deft_Hands"] = {
        cost = 1, requirements = { skill_points = { Melee = 1 } },
        prompt_desc = "(Melee) Has learned the basic usage of various weapons. When generating melee combat choices, describe the technical utilization of traits based on the weapon type. E.g., Sword: Winding, crossguard binding, false edge cuts, half-swording, unorthodox Mordhau. Axe/Polearm: Hooking, haft strikes. Mace: Technical handling using wrist snaps."
    },
    ["Tempo_Melee"] = {
        cost = 1, requirements = { skill_points = { Melee = 2 } }, group = "Melee_Style_1"
    },
    ["Combat_Training_Melee"] = {
        cost = 1, requirements = { skill_points = { Melee = 2 } }, group = "Melee_Style_1"
    },
    ["Berserk"] = {
        cost = 1, requirements = { skill_points = { Melee = 2 } }, group = "Melee_Style_1",
        prompt_desc = "(Melee) Relies on frenzy rather than calmness during combat. Refer to this when generating melee combat choices."
    },
    ["Footwork"] = {
        cost = 1, requirements = { skill_points = { Melee = 3 } }, group = "Melee_Defense",
        prompt_desc = "(Melee) Primarily uses nimble footwork and deflections when defending against attacks. Refer to this when generating defense and evasion choices."
    },
    ["Bulwark"] = {
        cost = 1, requirements = { skill_points = { Melee = 3 } }, group = "Melee_Defense",
        prompt_desc = "(Melee) Primarily uses parrying, blocking, and armor when defending against attacks. Refer to this when generating defense and evasion choices."
    },
    ["Vanguard"] = {
        cost = 1, requirements = { skill_points = { Melee = 4 } }, group = "Melee_Role",
        prompt_desc = "(Melee) In melee combat, {{user}}'s primary tactic is to confront enemies head-on and hold the front line."
    },
    ["Swashbuckler"] = {
        cost = 1, requirements = { skill_points = { Melee = 4 } }, group = "Melee_Role",
        prompt_desc = "(Melee) In melee combat, {{user}}'s primary tactic is to exploit the chaos of the battlefield to attack enemies boldly yet elusively."
    },
    ["Veteran_Melee"] = {
        cost = 1, requirements = { skill_points = { Melee = 5 } }, group = "Melee_Mastery"
    },
    ["Champion_Melee"] = {
        cost = 1, requirements = { skill_points = { Melee = 5 } }, group = "Melee_Mastery"
    },

    -- [Marksmanship Perks]
    ["Bullseye"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 1 } },
        prompt_desc = "(Marksmanship) Learned the basics and characteristics of archery; capable of trick shots, arcing shots, and aiming for weak points. Refer to this when generating Marksmanship choices."
    },
    ["Tempo_Archery"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 2 } }, group = "Archery_Style_1"
    },
    ["Combat_Training_Archery"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 2 } }, group = "Archery_Style_1"
    },
    ["Spray_and_Pray"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 2 } }, group = "Archery_Style_1",
        prompt_desc = "(Marksmanship) {{user}} prefers forming a barrage with rapid fire rather than precise shooting. Refer to this when generating Marksmanship choices."
    },
    ["Marksman"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 4 } }, group = "Archery_Style_2",
        prompt_desc = "(Marksmanship) Prefers calculated shots that suppress and neutralize the enemy."
    },
    ["Skirmisher"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 4 } }, group = "Archery_Style_2",
        prompt_desc = "(Marksmanship) Prefers tactics that harass and pressure the enemy continuously."
    },
    ["Second_Shot"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 3 } }, group = "Archery_Defense"
    },
    ["Tactical_Redeployment"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 3 } }, group = "Archery_Defense"
    },
    ["Veteran_Archery"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 5 } }, group = "Archery_Mastery"
    },
    ["Champion_Archery"] = {
        cost = 1, requirements = { skill_points = { Marksmanship = 5 } }, group = "Archery_Mastery"
    },

    -- [Athletics Perks]
    ["Toughness"] = {
        cost = 1, requirements = { skill_points = { Athletics = 1 } }
    },
    ["Indomitable"] = {
        cost = 1, requirements = { skill_points = { Athletics = 2 } }, group = "Athletics_Style"
    },
    ["Iron_Lungs"] = {
        cost = 1, requirements = { skill_points = { Athletics = 2 } }, group = "Athletics_Style"
    },
    ["Agile"] = {
        cost = 1, requirements = { skill_points = { Athletics = 3 } },
        prompt_desc = "(Athletics) Fast and light-footed. Can easily climb buildings or trees."
    },
    ["Unstoppable_Force"] = {
        cost = 1, requirements = { skill_points = { Athletics = 3 } },
        prompt_desc = "(Athletics) Incredibly strong. Can throw opponents larger than {{user}} or match their strength."
    },

    -- [Stealth Perks]
    ["Low_Profile"] = {
        cost = 1, requirements = { skill_points = { Stealth = 1 } }
    },
    ["Stealth_Training"] = {
        cost = 1, requirements = { skill_points = { Stealth = 1 } }
    },
    ["Master_of_Escape"] = {
        cost = 1, requirements = { skill_points = { Stealth = 1 } },
        prompt_desc = "(Stealth) When a stealth attempt fails, can use tools(eg. Smokebomb) or terrain to escape and re-attempt stealth."
    },
    ["Thiefs_Luck"] = {
        cost = 1, requirements = { skill_points = { Stealth = 3 } }
    },
    ["Fearsome_Presence"] = {
        cost = 1, requirements = { skill_points = { Stealth = 4 } },
        prompt_desc = "(Stealth) Successful takedowns strike fear into nearby enemies."
    },

    -- [Survival Perks]
    ["Ranger"] = {
        cost = 1, requirements = { skill_points = { Survival = 1 } },
        prompt_desc = "(Survival) Accustomed to narrow terrain like forests and alleyways. Gain an advantage when fighting or tracking in similar environments."
    },
    ["Insight"] = {
        cost = 1, requirements = { skill_points = { Survival = 2 } }, group = "Survival_Style",
        prompt_desc = "(Survival) Skilled at noticing signs, tracks, and weaknesses, and sharing this information with allies."
    },
    ["Hunter"] = {
        cost = 1, requirements = { skill_points = { Survival = 2 } }, group = "Survival_Style",
        prompt_desc = "(Survival) Proficient in hunting due to talent or experience."
    },
    ["Animal_Whisperer"] = {
        cost = 1, requirements = { skill_points = { Survival = 3 } },
        prompt_desc = "(Survival) Knowledge of wildlife allows communication with animals, calming or taming them."
    },
    ["Folk_Remedies"] = {
        cost = 1, requirements = { skill_points = { Survival = 3 } },
        prompt_desc = "(Survival) Knows how to treat and care for wounds efficiently. Treated as having medical knowledge."
    },

    -- [Craftsmanship Perks]
    ["Trap_Expert"] = {
        cost = 1, requirements = { skill_points = { Craftsmanship = 3 } },
        prompt_desc = "(Craftsmanship) Can utilize improvised or prepared traps effectively."
    },
    ["Handyman"] = {
        cost = 1, requirements = { skill_points = { Craftsmanship = 1 } },
        prompt_desc = "(Craftsmanship) Excellent dexterity allows handling most tasks."
    },
    ["Architect"] = {
        cost = 1, requirements = { skill_points = { Craftsmanship = 3 } },
        prompt_desc = "(Craftsmanship) Thoroughly understands building structures. Can discover hidden routes."
    },
    ["Quartermaster"] = {
        cost = 1, requirements = { skill_points = { Craftsmanship = 3 } },
        prompt_desc = "(Craftsmanship) Meticulously maintains equipment, ensuring it performs at its peak. {{user}}'s gear is of exceptional quality."
    },

    -- [Speech Perks]
    ["Camaraderie"] = {
        cost = 1, requirements = { skill_points = { Speech = 1 } },
        prompt_desc = "(Speech) Knows how to elicit help and cooperation from allies."
    },
    ["Basic_Speech"] = {
        cost = 1, requirements = { skill_points = { Speech = 1 } }
    },
    ["Orator"] = {
        cost = 1, requirements = { skill_points = { Speech = 3 } }, group = "Speech_Style",
        prompt_desc = "(Speech) Excellent rhetoric. Can argue logically and persuasively."
    },
    ["Loudmouth"] = {
        cost = 1, requirements = { skill_points = { Speech = 3 } }, group = "Speech_Style",
        prompt_desc = "(Speech) Excellent rhetoric. Overwhelms opponents with endless, verbose talking."
    },
    ["Silence_is_Gold"] = {
        cost = 1, requirements = { skill_points = { Speech = 3 } }, group = "Speech_Style",
        prompt_desc = "(Speech) Excellent rhetoric. Persuades others with concise words and impressive actions."
    },
    ["Intimidating_Presence"] = {
        cost = 1, requirements = { skill_points = { Speech = 3 } }, group = "Speech_Charm",
        prompt_desc = "(Speech) Presence alone can be a means of persuasion or gaining trust, backed by martial prowess."
    },
    ["Snake_Tongue"] = {
        cost = 1, requirements = { skill_points = { Speech = 3 } }, group = "Speech_Charm",
        prompt_desc = "(Speech) Can taunt or provoke opponents to create favorable situations."
    },
    -- [Scholarship Perks]
    ["Fast_Learner"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 1 } },
        prompt_desc = "(Scholarship) Learns and absorbs information quickly."
    },
    ["Basic_Scholarship"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 1 } },
        prompt_desc = "(Scholarship) Can read, write, and speak well. Treated as a person of common sense."
    },
    ["Tactician"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 3 } }, group = "Scholarship_Job",
        prompt_desc = "(Scholarship) Knowledgeable in tactics and strategy. Can utilize allies effectively."
    },
    ["Medic"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 3 } }, group = "Scholarship_Job",
        prompt_desc = "(Scholarship) Excellent in medicine. Manages allies' health and diet."
    },
    ["Alchemist"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 3 } }, group = "Scholarship_Job",
        prompt_desc = "(Scholarship) Can create and use poisons, explosives, and enhancers to strengthen allies."
    },
    ["Martial_Scholar"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 5 } }, group = "Scholarship_Lore",
        prompt_desc = "(Scholarship) Deeply read in martial arts manuals. Applies academic knowledge to combat."
    },
    ["Jack_of_All_Trades"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 5 } }, group = "Scholarship_Lore",
        prompt_desc = "(Scholarship) A repository of miscellaneous knowledge applicable to various situations."
    },
    ["Lore_Master"] = {
        cost = 1, requirements = { skill_points = { Scholarship = 5 } }, group = "Scholarship_Lore",
        prompt_desc = "(Scholarship) A walking history book. Possesses immense knowledge."
    }
}