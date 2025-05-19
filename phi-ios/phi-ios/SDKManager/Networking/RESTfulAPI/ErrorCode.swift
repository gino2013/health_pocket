//
//  ErrorCode.swift
//  SDK
//
//  Created by Kenneth on 2023/9/25.
//

import Foundation

/**
 Error code from server API
 */
enum ErrorCode: String {
    case runtimeException = "YX-COMMON-RUNTIME_EXCEPTION"
    case unknowException = "YX-COMMON-UNKNOWN_EXCEPTION"
    case tooManyRequest = "TOO_MANY_REQUEST"

    // US
    case newOldPasswordIsSame = "US_NEW_OLD_PASSWORD_IS_SAME_ERROR"
    case oldPasswordError = "US_OLD_PASSWORDE_ERROR"
    case oldPaymentPasswordError = "US_OLD_PAYMENT_PASSWORDE_ERROR"
    case incorrectPasswordError = "US_INCORRECT_PASSWORD_ERROR"
    case customerNotExistError = "US_CUSTOMER_NOT_EXIST_ERROR"
    case forbiddenLoginError = "US_FORBIDDEN_LOGIN_ERROR"
    case paymentPasswordExpire = "PAYMENT_PASSWORD_EXPIRE"
    case customerIllegalRecommender = "US_CUSTOMER_ILLEGAL_RECOMMENDER_ERROR"

    // CP
    case userLoginDeny = "CP_USER_LOGIN_DENY"
    case userWithdrawDeny = "CP_USER_WITHDRAW_DENY"
    case userRegisterDeny = "CP_USER_REGISTER_DENY"
    case autoRegLinkAmountExceedLimit = "CP_AUTO_REG_LINK_AMOUNT_EXCEED_LIMIT_ERROR"
    case autoRegLinkNotExist = "CP_AUTO_REG_LINK_NOT_EXIST_ERROR"

    var isBaseError: Bool {
        switch self {
        case .runtimeException, .unknowException:
            return true
        default:
            return false
        }
    }

    var localizedDescription: String {
        switch self {
        case .runtimeException, .unknowException:
            return "系統無法處理您的要求。請稍後重試或聯絡客服。"
        default:
            return PropertyUtils.readLocalizedProperty(rawValue)
        }
    }
}

/* 0: The operation couldn’t be completed. */
let errorCodeMapping = ["-1001": "請求超時，沒有回應",
                        "0": "操作無法完成",
                        "APP00000": "密碼格式有誤，需設定英文與數字6~12碼",
                        "APP00001": "與新登入密碼輸入不一致",
                        "SRV00002": "BU代码不能放空",
                        "SER00003": "用户名不能放空",
                        "MEM00004": "用户名或密码无效。",
                        "MEM00005": "请至少输入一个搜索条件",
                        "MEM00006": "用户名不能放空",
                        "MEM00007": "注意事项不能放空",
                        "MEM00008": "查无此会员注意事项",
                        "MEM00009": "更新日期不能放空",
                        "MEM00010": "日期不可放空或最小日期时间",
                        "MEM00011": "日期不可放空或最小日期时间",
                        "MEM00012": "结束日期不能早或等于开始日期",
                        "MEM00013": "自我限制设置错误",
                        "MEM00014": "IP地址不能放空",
                        "MEM00015": "信息日志不能放空",
                        "MEM00016": "请输入新的信息日志",
                        "MEM00017": "服务器根路径不能放空",
                        "MEM00018": "语言模板不能放空",
                        "MEM00019": "邮件模板不能放空",
                        "MEM00020": "邮件模板错误",
                        "MEM00021": "用户角色不能放空",
                        "MEM00022": "货币不能放空",
                        "MEM00023": "备注栏不能放空",
                        "MEM00024": "配置名称不能放空",
                        "MEM00025": "密码不能放空",
                        "MEM00026": "登入昵称已被他人使用，请重新填写。",
                        "MEM00027": "邮箱网域不存在",
                        "MEM00028": "请选择语言",
                        "MEM00029": "注册成功",
                        "MEM00031": "联系电话已被他人使用，请重新填写。",
                        "MEM00032": "注册网站ID不符合",
                        "MEM00033": "发生错误，请您联系客服",
                        "MEM00034": "这个用户名不太恰当哦！请重新填写。",
                        "MEM00035": "注册网站无效，注册失败",
                        "MEM00036": "注册失败",
                        "MEM00038": "注册失败。",
                        "MEM00039": "联系电话不能放空",
                        "MEM00040": "新联系电话不能放空",
                        "MEM00041": "电子邮箱地址已被他人使用，请重新填写。",
                        "MEM00042": "联系号码状态不存在",
                        "MEM00043": "联系号码无效",
                        "MEM00044": "QQ格式错误",
                        "MEM00045": "MSN格式错误",
                        "MEM00046": "Yahoo格式错误",
                        "MEM00047": "手机号码格式错误。请重新检查！（长度至少5个数码及只允许 - 跟 + 符号)",
                        "MEM00048": "座机号码格式错误。请重新检查！（长度至少5个数码及只允许 - 跟 + 符号)",
                        "MEM00049": "邮箱格式错误",
                        "MEM00050": "此次更新没有任何变动",
                        "MEM00051": "电话号码不存在",
                        "MEM00052": "联系人状态无效",
                        "MEM00053": "验证码不能放空",
                        "MEM00054": "消息不能放空",
                        "MEM00055": "消息类型错误",
                        "MEM00056": "名字不能放空",
                        "MEM00057": "登陆失败。请咨询在线客服协助。",
                        "MEM00058": "IP错误",
                        "MEM00059": "用户名或密码无效。",
                        "MEM00060": "您已超过尝试的限制，请联系在线客服！",
                        "MEM00061": "您已无法登入账号。若有任何疑问，欢迎咨询在线客服协助。",
                        "MEM00062": "账户冻结",
                        "MEM00063": "您的账号无法使用,请联系在线客服",
                        "MEM00064": "用户姓名包含不文明用语",
                        "MEM00065": "安全验证无效",
                        "MEM00066": "成功",
                        "MEM00067": "可用次数仅限一次",
                        "MEM00068": "已过期",
                        "MEM00069": "链接不能放空",
                        "MEM00070": "链接无效",
                        "MEM00071": "无法更新信使详细信息",
                        "MEM00072": "联系类型无效",
                        "MEM00073": "请求失败，年龄限制不符合标准要求！",
                        "MEM00074": "新密码不能与旧密码一致",
                        "MEM00075": "个人资料更新成功",
                        "MEM00076": "无法更新会员订阅",
                        "MEM00077": "ID无效",
                        "MEM00078": "钱包不能放空",
                        "MEM00079": "会员没有注册泰坦项目",
                        "MEM00080": "会员之前成功登录过",
                        "MEM00081": "无可用主要电子邮箱",
                        "MEM00082": "电子邮箱不能放空",
                        "MEM00083": "安全问题不能放空",
                        "MEM00084": "安全答案不能放空",
                        "MEM00085": "不允许添加D-手机",
                        "MEM00086": "不允许更新D-手机",
                        "MEM00087": "微信号格式错误",
                        "MEM00088": "手机号码不能放空",
                        "MEM00089": "用户名无效",
                        "MEM10001": "查无此邮件模板",
                        "MEM10002": "重置密码链接生成失败",
                        "MEM10003": "会员更新错误",
                        "MEM10005": "密码更新错误",
                        "MEM10006": "安全信息更新错误",
                        "MEM10007": "密码键更新错误",
                        "MEM90000": "暂不支持次功能",
                        "MEM00126": "乐天堂账户与PT老虎机账户密码不能相同",
                        "MEM00141": "账号已停用",
                        "VERI00000": "查无此记录",
                        "VERI00001": "BU代码错误",
                        "VERI00002": "BU代码不能放空",
                        "VERI00003": "用户名不能放空",
                        "VERI00004": "用户名不能放空",
                        "VERI00005": "首选语言不能放空",
                        "VERI00006": "货币代码不能放空",
                        "VERI00007": "配置名称不能放空",
                        "VERI00008": "IP地址不能放空",
                        "VERI00009": "代币不能放空",
                        "VERI00010": "备注不能放空",
                        "VERI00011": "电子邮箱不能放空",
                        "VERI00012": "CV链接标识无效",
                        "VERI00013": "CV Json值无效",
                        "VERI10001": "验证链接生成不被允许。 请再次检查状态。",
                        "VERI10002": "代币已过期",
                        "VERI10003": "代币无效",
                        "VERI10004": "代币不存在",
                        "VERI10005": "代币验证成功",
                        "VERI10006": "无法生成代币",
                        "VERI10007": "电子邮箱已更新",
                        "VERI10008": "电子邮箱无效",
                        "VERI10009": "代币更新错误",
                        "VERI20001": "获取联系人时出错",
                        "VERI20002": "联系号码不存在",
                        "VERI20003": "联系号码更新错误",
                        "CPL00000": "查无此记录",
                        "CPL00001": "BU代码无效",
                        "CPL00002": "BU代码不能放空",
                        "CPL00003": "用户名不能放空",
                        "CPL00004": "查获不文明用语",
                        "CPL00005": "电子邮箱不能放空",
                        "CPL00006": "查获禁止的电子邮件",
                        "CPL00007": "禁止类型无效",
                        "CPL00008": "价值不能放空",
                        "CPL00009": "请求类型不能放空",
                        "CPL00010": "设备已列入黑名单",
                        "CPL00011": "设备ID不能放空",
                        "CPL00012": "查无会员记录",
                        "CPL00013": "查无创新记录",
                        "CPL00014": "手机号码格式错误。请重新检查！（长度至少5个数码及只允许 - 跟 + 符号)",
                        "CPL00015": "成功",
                        "CPL00016": "此电子邮箱已被使用",
                        "CPL00017": "此电话号码已被使用",
                        "CPL00018": "此用户名已被使用",
                        "CPL00019": "注册网站ID不符合",
                        "CPL00020": "此设备已被列入黑名单",
                        "CPL00021": "用户名称包含不文明用语",
                        "CPL00022": "注册网站ID不存在",
                        "CPL00023": "此IP已被列入黑名单",
                        "CPL00024": "由管理人员禁止使用名称（?? ?? ???）的重要风险欺诈者。",
                        "CPL00025": "用户自我限制启动中，不允许登录",
                        "CPL00026": "密码无效",
                        "CPL00027": "无法重置密码。 无此用户名",
                        "CPL00028": "自我限制更新失败",
                        "CPL00029": "用户名或密码无效",
                        "CPL00030": "登出失败",
                        "CPL00031": "调用的对象是空的",
                        "CPL00032": "查无此品牌",
                        "CPL00033": "使用黑名单IP登录",
                        "CPL00034": "使用黑名单设备登录",
                        "CPL00035": "TempID无效",
                        "CPL00036": "不允许保存空值",
                        "CPL00037": "价值重复",
                        "CPL00040": "日期时间格式无效",
                        "CPL00041": "日期时间范围无效",
                        "CPL00042": "用户名不能放空",
                        "CPL00043": "SQL命令发生超时错误。 请联系您的SQL命令发生超时错误。 请联系您的管理员。",
                        "CPL00044": "手机号码不能放空",
                        "CPL00045": "IP地址不能放空",
                        "CPL00046": "存款账户不能放空",
                        "CPL00047": "提款账户不能放空",
                        "CPL00048": "采取行动不能放空",
                        "CPL00049": "创建者不能放空",
                        "CPL00050": "规则条件无效",
                        "CPL00051": "风险级别无效",
                        "CPL00052": "系统操作无效",
                        "CPL00053": "模块无效",
                        "CPL00054": "交易序号无效",
                        "CPL00055": "分配者不能放空",
                        "CPL00056": "被分配者不能放空",
                        "CPL00057": "分配状态无效",
                        "CPL00058": "更新者不能放空",
                        "CPL00059": "产品不能放空",
                        "CPL00060": "黑盒子值无效",
                        "CPL00061": "红利ID无效",
                        "CPL00062": "红利类型无效",
                        "CPL10001": "黑名单类型无效",
                        "CPL10002": "电话号码格式无效。长度至少5位数码",
                        "CPL10003": "电子邮箱格式无效",
                        "CPL10004": "IP地址格式无效",
                        "CPL10005": "设备序号无效。设备序号只能包含数字",
                        "CPL10006": "存款账户格式无效。存款账户只能包含数字",
                        "CPL10007": "提款账户格式无效。提款账户只能包含数字",
                        "CPL10008": "身份证号码格式无效。 身份证号码只能包含字母和数字",
                        "CPL10009": "用户名格式无效。 用户名只能包含字母和数字",
                        "CPL10010": "此次更新没有任何变动",
                        "CPL10011": "该品牌不支持此模块",
                        "CPL10012": "Buyapowa状态无效",
                        "CPL10013": "备注不能放空"]
