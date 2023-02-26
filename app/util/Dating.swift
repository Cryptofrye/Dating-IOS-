//
//  Dating.swift
//
//  Created by Demyanchuk Dmitry on 24.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//


import UIKit

class Dating {
    
    static func getGender(sex: Int)->String {
        
        switch sex {
            
        case Constants.SEX_MALE:
            
            return NSLocalizedString("label_male", comment: "")
            
        case Constants.SEX_FEMALE:
            
            return NSLocalizedString("label_female", comment: "")
            
        default:
            
            return NSLocalizedString("label_undefined", comment: "")
        }
    }
    
    static func getSexOrientation(sex_orientation: Int)->String {
        
        switch sex_orientation {
            
        case 1:
            
            return NSLocalizedString("label_sex_orientation_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("label_sex_orientation_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("label_sex_orientation_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("label_sex_orientation_4", comment: "")
            
        default:
            
            return NSLocalizedString("label_sex_orientation_select", comment: "")
        }
    }
    
    static func getRelationshipStatus(relationshipStatus: Int)->String {
        
        switch relationshipStatus {
            
        case 1:
            
            return NSLocalizedString("relationship_status_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("relationship_status_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("relationship_status_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("relationship_status_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("relationship_status_5", comment: "")
            
        case 6:
            
            return NSLocalizedString("relationship_status_6", comment: "")
            
        case 7:
            
            return NSLocalizedString("relationship_status_7", comment: "")
            
        default:
            
            return NSLocalizedString("relationship_status_0", comment: "")
        }
    }
    
    static func getPoliticalViews(politicalViews: Int)->String {
        
        switch politicalViews {
            
        case 1:
            
            return NSLocalizedString("political_views_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("political_views_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("political_views_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("political_views_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("political_views_5", comment: "")
            
        case 6:
            
            return NSLocalizedString("political_views_6", comment: "")
            
        case 7:
            
            return NSLocalizedString("political_views_7", comment: "")
            
        case 8:
            
            return NSLocalizedString("political_views_8", comment: "")
            
        case 9:
            
            return NSLocalizedString("political_views_9", comment: "")
            
        default:
            
            return NSLocalizedString("political_views_0", comment: "")
        }
    }
    
    static func getWorldViewsViews(worldViews: Int)->String {
        
        switch worldViews {
            
        case 1:
            
            return NSLocalizedString("world_view_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("world_view_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("world_view_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("world_view_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("world_view_5", comment: "")
            
        case 6:
            
            return NSLocalizedString("world_view_6", comment: "")
            
        case 7:
            
            return NSLocalizedString("world_view_7", comment: "")
            
        case 8:
            
            return NSLocalizedString("world_view_8", comment: "")
            
        case 9:
            
            return NSLocalizedString("world_view_9", comment: "")
            
        default:
            
            return NSLocalizedString("world_view_0", comment: "")
        }
    }
    
    static func getPersonalPriority(personalPriority: Int)->String {
        
        switch personalPriority {
            
        case 1:
            
            return NSLocalizedString("personal_priority_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("personal_priority_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("personal_priority_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("personal_priority_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("personal_priority_5", comment: "")
            
        case 6:
            
            return NSLocalizedString("personal_priority_6", comment: "")
            
        case 7:
            
            return NSLocalizedString("personal_priority_7", comment: "")
            
        case 8:
            
            return NSLocalizedString("personal_priority_8", comment: "")
            
        default:
            
            return NSLocalizedString("personal_priority_0", comment: "")
        }
    }
    
    static func getImportantInOthers(importantInOthers: Int)->String {
        
        switch importantInOthers {
            
        case 1:
            
            return NSLocalizedString("important_in_others_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("important_in_others_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("important_in_others_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("important_in_others_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("important_in_others_5", comment: "")
            
        case 6:
            
            return NSLocalizedString("important_in_others_6", comment: "")
            
        default:
            
            return NSLocalizedString("important_in_others_0", comment: "")
        }
    }
    
    static func getSmokingViews(smokingViews: Int)->String {
        
        switch smokingViews {
            
        case 1:
            
            return NSLocalizedString("smoking_views_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("smoking_views_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("smoking_views_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("smoking_views_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("smoking_views_5", comment: "")
            
        default:
            
            return NSLocalizedString("smoking_views_0", comment: "")
        }
    }
    
    static func getAlcoholViews(alcoholViews: Int)->String {
        
        switch alcoholViews {
            
        case 1:
            
            return NSLocalizedString("alcohol_views_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("alcohol_views_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("alcohol_views_3", comment: "")
            
        case 4:
            
            return NSLocalizedString("alcohol_views_4", comment: "")
            
        case 5:
            
            return NSLocalizedString("alcohol_views_5", comment: "")
            
        default:
            
            return NSLocalizedString("alcohol_views_0", comment: "")
        }
    }
    
    static func getLookingFor(lookingFor: Int)->String {
        
        switch lookingFor {
            
        case 1:
            
            return NSLocalizedString("you_looking_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("you_looking_2", comment: "")
            
        case 3:
            
            return NSLocalizedString("you_looking_3", comment: "")
            
        default:
            
            return NSLocalizedString("you_looking_0", comment: "")
        }
    }
    
    static func getGenderLike(genderLike: Int)->String {
        
        switch genderLike {
            
        case 1:
            
            return NSLocalizedString("gender_like_1", comment: "")
            
        case 2:
            
            return NSLocalizedString("gender_like_2", comment: "")
            
        default:
            
            return NSLocalizedString("you_looking_0", comment: "")
        }
    }
}
