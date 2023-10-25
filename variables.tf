variable "lc_name" {
  description = "Launch Configuration 이름"
  type        = string
}

variable "server_image_name" {
  description = "서버 이미지 이름"
  type        = string
  default     = null
}

variable "member_server_image_name" {
  description = "내 서버 이미지 이름"
  type        = string
  default     = null
}

variable "product_generation" {
  description = "서버 세대 (G1 | G2)"
  type        = string
}

variable "product_type" {
  description = "서버 타입 (High CPU | Standard | High Memory | CPU Intensive | GPU | BareMetal)"
  type        = string
}

variable "product_name" {
  description = "서버 스펙 이름"
  type        = string
}

variable "login_key_name" {
  description = "서버 접속 키(.pem) 이름"
  type        = string
}

variable "is_encrypted_volume" {
  description = "암호화 볼륨 사용 여부"
  type        = bool
  default     = false
}

variable "init_script_no" {
  description = "Init Script 번호"
  type        = string
  default     = null
}

variable "login_key_name" {
  description = "서버 접속 키(.pem) 이름"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group 이름"
  type        = string
}

variable "subnet_no" {
  description = "Subnet 번호"
  type        = string
}

variable "server_name_prefix" {
  description = "서버 이름 접두사"
  type        = string
}

variable "min_size" {
  description = "최소 용량"
  type        = number
}

variable "max_size" {
  description = "최대 용량"
  type        = number
}

variable "desired_capacity" {
  description = "기대 용량"
  type        = number
}

variable "ignore_capacity_changes" {
  description = "용량 변경 무시 여부"
  type        = bool
  default     = false
}

variable "default_cooldown" {
  description = "기본 쿨다운 시간 (초)"
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "헬스 체크 보류 시간 (초)"
  type        = number
  default     = 300
}

variable "health_check_type_code" {
  description = "헬스 체크 타입 (SVR | LOADB)"
  type        = string
  default     = "SVR"
}

variable "access_control_group_no_list" {
  description = "ACG 번호 리스트"
  type        = list(string)
}

variable "target_group_list" {
  description = "Target Group 리스트"
  type        = list(string)
}

# variable "wait_for_capacity_timeout" {
#   description = "용량 변경 대기 시간 (초)"
#   type        = number
#   default     = 300
# }

variable "auto_scaling_policies" {
  description = "Auto Scaling Policy 리스트"
  type = list(object({
    name                 = string # Scaling 정책 이름
    adjustment_type_code = string # Scaling 설정 타입 (CHANG(증감변경) | EXACT(고정값) | PRCNT(비율변경))
    scaling_adjustment   = number # Scaling 설정 값 (증감변경: 증감 수치(음수 가능) | 고정값: 고정값 | 비율변경: 비율(음수 가능))
    min_adjustment_step  = number # 최소 증감 폭 (비율변경 타입일 경우에만 사용)
    cooldown             = number # 쿨다운 시간 (초)
  }))
}

variable "auto_scaling_schedules" {
  description = "Auto Scaling Schedule 리스트"
  type = list(object({
    name             = string #  Scaling 일정 이름
    min_size         = number # 최소 용량
    max_size         = number # 최대 용량
    desired_capacity = number # 기대 용량
    time_zone        = string # 타임존 (KST | UTC)
    start_time       = string # 시작 시간 (Format : yyyy-MM-ddTHH:mm:ssZ format in UTC/KST only (for example, 2021-02-02T18:00:00+0900))
    recurrence       = string # 반복 설정 (리눅스 Cronjob 형식 입력 (예) 5 * * * * -> 5분 *시간 *일 *월 *요일)
    end_time         = string # 종료 시간 (Format : yyyy-MM-ddTHH:mm:ssZ format in UTC/KST only (for example, 2021-02-02T18:00:00+0900))
  }))
}
