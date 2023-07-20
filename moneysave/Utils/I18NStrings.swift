//
//  I18NStrings.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import Foundation

struct I18NStrings {
    /// 확인
    static let confirm = "confirm".localized
    /// 취소
    static let cancel = "cancel".localized
    /// ROUMO
    static let logoText = "lotoText".localized
    /// 추가하기
    static let add = "add".localized
    /// 저장하기
    static let save = "save".localized
    /// 수정하기
    static let edit = "edit".localized
    /// 오류
    static let error = "error".localized
    
    struct Login {
        /// 네이버로 로그인
        static let naver = "loginNaver".localized
        /// 구글로 로그인
        static let google = "loginGoogle".localized
        /// Apple로 로그인
        static let apple = "loginApple".localized
        /// 이메일로 로그인
        static let email = "loginEmail".localized
        /// 로그인할 이메일을 입력해 주세요
        static let email_Title = "loginEmailTitle".localized
        /// 이메일
        static let email_Place = "loginEmailPlace".localized
        /// 메일형식으로 입력해주세요
        static let email_Vali = "loginEmailVali".localized
        /// 인증메일을 받지 못하셨다면....
        static let email_Guide = "loginEmailGuide".localized
        /// 메일 주소로 인증 메일이...
        static let email_Alert = "loginEmailAlert".localized
        /// 인증 메일 발송
        static let email_Alert_Title = "loginEmailAlertTitle".localized
        /// 이용약관에 동의해주세요
        static let terms_Title = "loginTermsTitle".localized
        /// 전체동의
        static let terms_All = "loginTermsAll".localized
        /// 개인정보 처리방침
        static let terms_Privacy = "loginTermsPrivacy".localized
        /// 동의하고 계속하기
        static let terms_Next = "loginTermsNext".localized
        /// 서비스 이용 약관
        static let terms_Service_Title = "loginServiceTermsTitle".localized
        /// 개인 정보 처리 방침
        static let terms_User_Title = "loginUserTermsTitle".localized
        /// 인증 실패
        static let email_Alert_Error_Title = "loginEmailAlertErrorTitle".localized
        /// 다른 계정으로 시도해 보세요
        static let error_Success = "loginSuccessError".localized
        /// 서비스 오류로 인해 로그인이 안되....
        static let error_API = "loginAPIError".localized
        
    }
    
    struct Main {
        /// 홈
        static let home = "home".localized
        /// 루틴추천
        static let sugRoutine = "sugRoutine".localized
        /// 내정보
        static let mypage = "mypage".localized
    }
    
    struct Routine {
        /// 루틴 추가하기
        static let add = "routineAdd".localized
        /// 루틴 수정하기
        static let edit = "routineEdit".localized
        /// 루틴명은 무엇인가요?
        static let name = "routineName".localized
        /// 루틴명을 입력해주세요.
        static let namePlace = "routineNamePlace".localized
        /// 루틴의 카테고리를 설정해주세요
        static let category = "routineCategory".localized
        /// 카테고리명을 입력해주세요.
        static let categoryPlace = "routineCategoryPlace".localized
        /// 루틴을 언제 반복할까요?
        static let `repeat` = "routineRepeat".localized
        /// 루틴을 수행할 시간대를 설정해주세요.
        static let time = "routineTime".localized
        /// 알림이 필요하세요?
        static let alarm = "routineAlarm".localized
        /// → 몇시에 알려드릴까요?
        static let alarmSub = "routineSubAlarm".localized
        /// 카테고리 추가하기
        static let categoryAdd = "routineCategoryAdd".localized
        /// 루틴 추가는 당일만 가능해요
        static let addMsg = "routineAddMsg".localized
        /// 해당 루틴을 정말 삭제하시겠어요?
        static let deleteMsg = "routineDeleteMsg".localized
        /// 루틴 체크는 당일만 가능해요
        static let checkMsg = "routineCheckMsg".localized
        /// 오늘 추린 체크는 다 완료 하셨나요?
        static let systemPushMsg = "routineSystemPushMsg".localized
    }
    
    struct Sug {
        /// 업데이트 예정이에요
        static let title = "sugTitle".localized
        /// 추후 업데이트 예정이니 조금만 기다려주세요
        static let sub = "sugSub".localized
    }
    
    struct MyPage {
        /// 카테고리 수정
        static let category = "myPageCategory".localized
        /// 해당 카테고리를 삭제하시겠습니까?
        static let categoryMsg = "myPageCategoryMsg".localized
        /// 푸쉬 알림
        static let push = "myPagePush".localized
        /// 이용 약관
        static let terms = "myPageTerms".localized
        /// 개인정보 처리방침
        static let individual = "myPageIndividual".localized
        /// 도움말
        static let help = "myPageHelp".localized
        /// 로그아웃
        static let logout = "myPageLogout".localized
        /// 계정을 로그아웃 하시겠어요?
        static let logoutMsg = "myPageLogoutMsg".localized
        /// 회원탈퇴
        static let leave = "myPageLeave".localized
        /// 지금 탈퇴하시면 모든 루틴들이 사라져요!
        static let leaveMsg = "myPageLeaveMsg".localized
        /// 역시 그만둘래요
        static let leaveCancel = "myPageLeaveCancel".localized
        /// 알림이 설정되었어요!
        static let pushOn = "myPagePushOn".localized
        /// 알림이 해제되었어요!
        static let pushOff = "myPagePushOff".localized
        /// 애플로그인
        static let appleTitle = "myPageAppleTitle".localized
        /// 애플계정이 연동되었습니다.....
        static let appleMsg = "myPageAppleMsg".localized
    }
}
