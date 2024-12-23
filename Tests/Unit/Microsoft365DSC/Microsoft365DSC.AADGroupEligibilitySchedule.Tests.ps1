[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADGroupEligibilitySchedule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
            }

            Mock -CommandName New-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
            }

            Mock -CommandName Remove-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The AADGroupEligibilitySchedule should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "owner"
                    CreatedUsing = "FakeStringValue"
                    GroupId = "FakeStringValue"
                    Id = "FakeStringValue"
                    MemberType = "direct"
                    ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    PrincipalId = "FakeStringValue"
                    ScheduleInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphrequestSchedule -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence1 -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern1 -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange1 -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphexpirationPattern -Property @{
                            EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                            Type = "notSpecified"
                        } -ClientOnly)
                        StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    } -ClientOnly)
                    Status = "FakeStringValue"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "owner"
                    CreatedUsing = "FakeStringValue"
                    GroupId = "FakeStringValue"
                    Id = "FakeStringValue"
                    MemberType = "direct"
                    ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    PrincipalId = "FakeStringValue"
                    ScheduleInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphrequestSchedule -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence1 -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern1 -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange1 -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphexpirationPattern -Property @{
                            EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                            Type = "notSpecified"
                        } -ClientOnly)
                        StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    } -ClientOnly)
                    Status = "FakeStringValue"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            groupId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.PrivilegedAccessGroupEligibilitySchedule"
                            principalId = "FakeStringValue"
                            memberType = "direct"
                            accessId = "owner"
                        }
                        CreatedUsing = "FakeStringValue"
                        Id = "FakeStringValue"
                        ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        ScheduleInfo = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            Expiration = @{
                                EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                                Type = "notSpecified"
                            }
                            StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        }
                        Status = "FakeStringValue"

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1
            }
        }

        Context -Name "The AADGroupEligibilitySchedule Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "owner"
                    CreatedUsing = "FakeStringValue"
                    GroupId = "FakeStringValue"
                    Id = "FakeStringValue"
                    MemberType = "direct"
                    ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    PrincipalId = "FakeStringValue"
                    ScheduleInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphrequestSchedule -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence1 -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern1 -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange1 -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphexpirationPattern -Property @{
                            EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                            Type = "notSpecified"
                        } -ClientOnly)
                        StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    } -ClientOnly)
                    Status = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            groupId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.PrivilegedAccessGroupEligibilitySchedule"
                            principalId = "FakeStringValue"
                            memberType = "direct"
                            accessId = "owner"
                        }
                        CreatedUsing = "FakeStringValue"
                        Id = "FakeStringValue"
                        ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        ScheduleInfo = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            Expiration = @{
                                EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                                Type = "notSpecified"
                            }
                            StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        }
                        Status = "FakeStringValue"

                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADGroupEligibilitySchedule exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessId = "owner"
                    CreatedUsing = "FakeStringValue"
                    GroupId = "FakeStringValue"
                    Id = "FakeStringValue"
                    MemberType = "direct"
                    ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    PrincipalId = "FakeStringValue"
                    ScheduleInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphrequestSchedule -Property @{
                        Recurrence = (New-CimInstance -ClassName MSFT_MicrosoftGraphpatternedRecurrence1 -Property @{
                            Pattern = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrencePattern1 -Property @{
                                Index = "first"
                                FirstDayOfWeek = "sunday"
                                DayOfMonth = 25
                                Month = 25
                                DaysOfWeek = @("sunday")
                                Type = "daily"
                                Interval = 25
                            } -ClientOnly)
                            Range = (New-CimInstance -ClassName MSFT_MicrosoftGraphrecurrenceRange1 -Property @{
                                StartDate = "2023-01-01T00:00:00.0000000"
                                EndDate = "2023-01-01T00:00:00.0000000"
                                RecurrenceTimeZone = "FakeStringValue"
                                NumberOfOccurrences = 25
                                Type = "endDate"
                            } -ClientOnly)
                        } -ClientOnly)
                        Expiration = (New-CimInstance -ClassName MSFT_MicrosoftGraphexpirationPattern -Property @{
                            EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                            Type = "notSpecified"
                        } -ClientOnly)
                        StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                    } -ClientOnly)
                    Status = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            principalId = "FakeStringValue"
                            groupId = "FakeStringValue"
                            memberType = "direct"
                            accessId = "owner"
                        }
                        CreatedUsing = "FakeStringValue"
                        Id = "FakeStringValue"
                        ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        ScheduleInfo = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 7
                                    Month = 7
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 7
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 7
                                    Type = "endDate"
                                }
                            }
                            Expiration = @{
                                EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                                Type = "notSpecified"
                            }
                            StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        }
                        Status = "FakeStringValue"
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule -MockWith {
                    return @{
                        AdditionalProperties = @{
                            groupId = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.PrivilegedAccessGroupEligibilitySchedule"
                            principalId = "FakeStringValue"
                            memberType = "direct"
                            accessId = "owner"
                        }
                        CreatedUsing = "FakeStringValue"
                        Id = "FakeStringValue"
                        ModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        ScheduleInfo = @{
                            Recurrence = @{
                                Pattern = @{
                                    Index = "first"
                                    FirstDayOfWeek = "sunday"
                                    DayOfMonth = 25
                                    Month = 25
                                    DaysOfWeek = @("sunday")
                                    Type = "daily"
                                    Interval = 25
                                }
                                Range = @{
                                    StartDate = "2023-01-01T00:00:00.0000000"
                                    EndDate = "2023-01-01T00:00:00.0000000"
                                    RecurrenceTimeZone = "FakeStringValue"
                                    NumberOfOccurrences = 25
                                    Type = "endDate"
                                }
                            }
                            Expiration = @{
                                EndDateTime = "2023-01-01T00:00:00.0000000+01:00"
                                Type = "notSpecified"
                            }
                            StartDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        }
                        Status = "FakeStringValue"

                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
