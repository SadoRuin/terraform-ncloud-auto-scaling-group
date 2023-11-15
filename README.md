# NCP Auto Scaling Group Terraform module

네이버 클라우드 플랫폼의 Auto Scaling Group 모듈입니다.

## Table of Contents

- [Usage](#usage)
- [Resources](#resources)
  - [Auto Scaling Group](#auto-scaling-group)
- [Inputs](#inputs)
  - [Auto Scaling Policy Inputs](#auto-scaling-policy-inputs)
  - [Auto Scaling Schedule Inputs](#auto-scaling-schedule-inputs)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Providers](#providers)

## [Usage](#table-of-contents)

```hcl
module "asg" {
  source = "<THIS REPOSITORY URL>"

  launch_configuration_no = module.lc.launch_configuration.id

  name                    = "tf-test-asg"
  subnet_no               = module.tf_test_vpc.subnets["tf-test-web-sbn"].id
  server_name_prefix      = "web"
  min_size                = 0
  max_size                = 0
  desired_capacity        = 0
  ignore_capacity_changes = false

  default_cooldown          = 300
  health_check_grace_period = 300
  health_check_type_code    = "LOADB"

  access_control_group_no_list = [
    module.tf_test_vpc.acgs["tf-test-web-svr-acg"].id
  ]

  target_group_list = [
    module.target_groups.target_groups["tf-test-web-tg"].id
  ]
}
```

## [Resources](#table-of-contents)

### Auto Scaling Group

<!-- prettier-ignore -->
| Name | Type |
|------|------|
| [ncloud_auto_scaling_group.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/auto_scaling_group) | resource |
| [ncloud_auto_scaling_policy.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/auto_scaling_policy) | resource |
| [ncloud_auto_scaling_schedule.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/auto_scaling_schedule) | resource |

## [Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| launch_configuration_no | Launch Configuration ID | `string` | - | yes |
| name | Auto Scaling Group 이름 | `string` | - | yes |
| subnet_no | Subnet ID | `string` | - | yes |
| server_name_prefix | 서버 이름 접두사 | `string` | - | yes |
| min_size | 최소 용량 | `number` | - | yes |
| max_size | 최대 용량 | `number` | - | yes |
| desired_capacity | 기대 용량 | `number` | - | yes |
| ignore_capacity_changes | 용량 변경 무시 여부 | `bool` | `false` | no |
| default_cooldown | 기본 쿨다운 시간 (초) | `number` | `300` | no |
| health_check_grace_period | 헬스 체크 보류 시간 (초) | `number` | `300` | no |
| health_check_type_code | 헬스 체크 타입 (SVR \| LOADB) | `string` | `SVR` | no |
| access_control_group_no_list | ACG ID 리스트 | `list(string)` | - | yes |
| target_group_list | Target Group 리스트 (헬스 체크 타입이 LOADB일 경우에만 사용) | `list(string)` | `[]` | no |
| wait_for_capacity_timeout | 용량 변경 대기 시간 (초) | `string` | `null` | no |
| [auto_scaling_policies](#auto-scaling-policy-inputs) | Auto Scaling Policy 리스트 | <pre>list(object({<br>  name                 = string<br>  adjustment_type_code = string<br>  scaling_adjustment   = number<br>  min_adjustment_step  = optional(number)<br>  cooldown             = optional(number)<br>}))</pre> | `[]` | no |
| [auto_scaling_schedules](#auto-scaling-schedule-inputs) | Auto Scaling Schedule 리스트 | <pre>list(object({<br>  name             = string<br>  min_size         = number<br>  max_size         = number<br>  desired_capacity = number<br>  time_zone        = string<br>  start_time       = optional(string)<br>  recurrence       = optional(string)<br>  end_time         = optional(string)<br>}))</pre> | `[]` | no |

### [Auto Scaling Policy Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Scaling 정책 이름 | `string` | - | yes |
| adjustment_type_code | Scaling 설정 타입 (CHANG(증감변경) \| EXACT(고정값) \| PRCNT(비율변경)) | `string` | - | yes |
| scaling_adjustment | Scaling 설정 값 (증감변경: 증감 수치(음수 가능) \| 고정값: 고정값 \| 비율변경: 비율(음수 가능)) | `number` | - | yes |
| min_adjustment_step | 최소 증감 폭 (비율변경 타입일 경우에만 사용) | `number` | - | no |
| cooldown | 쿨다운 시간 (초) | `number` | - | no |

### [Auto Scaling Schedule Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Scaling 스케줄 이름 | `string` | - | yes |
| min_size | 최소 용량 | `number` | - | yes |
| max_size | 최대 용량 | `number` | - | yes |
| desired_capacity | 기대 용량 | `number` | - | yes |
| time_zone | 타임존 (KST \| UTC) | `string` | - | yes |
| start_time | 시작 시간 (Format : yyyy-MM-ddTHH:mm:ssZ format in UTC/KST only (for example, 2021-02-02T18:00:00+0900)) | `string` | - | no |
| recurrence | 반복 설정 (리눅스 Cronjob 형식 입력 (예) 5 * * * * -> 5분 *시간 *일 *월 *요일) | `string` | - | no |
| end_time | 종료 시간 (Format : yyyy-MM-ddTHH:mm:ssZ format in UTC/KST only (for example, 2021-02-02T18:00:00+0900)) | `string` | - | no |

## [Outputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Key값 (Map 형식) |
|------|-------------|-----------------|
| auto_scaling_group | Auto Scaling Group 리소스 출력 | - |
| auto_scaling_policy | Auto Scaling Policy 리소스들을 Map형식으로 출력 | `"Scaling 정책 이름"` |
| auto_scaling_schedule | Auto Scaling Schedule 리소스들을 Map형식으로 출력 | `"Scaling 스케줄 이름"` |

## [Requirements](#table-of-contents)

<!-- prettier-ignore -->
| Name | Version |
|------|---------|
| [terraform](https://developer.hashicorp.com/terraform/install) | >= 1.0    |
| [ncloud](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest) | >= 2.3.18 |

## [Providers](#table-of-contents)

<!-- prettier-ignore -->
| Name | Version |
|------|---------|
| [ncloud](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest) | >= 2.3.18 |
