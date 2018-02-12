podTemplate(label: 'jnlp-slave', 
    name:"jnlp-slave",
    containers: [
        containerTemplate(
            name: 'jnlp',
            image: 'dengyc/jnlp-slave'
        )        
    ]
    ,volumes: [
        hostPathVolume(hostPath: '/usr/bin/docker', mountPath: '/bin/docker'),
        hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
    ]
){
    node ('jnlp-slave') {      
        withEnv([
            'REGISTRY_API=192.168.31.240:5000',
            'ROOT_DOMAIN=hicoin.io',
            'DEPLOY_ENV=LOCAL'
        ]){
            stage('获取代码') {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[                    
                        $class: 'SubmoduleOption',
                        disableSubmodules: false, 
                        parentCredentials: false, 
                        recursiveSubmodules: true, 
                        reference: '', 
                        trackingSubmodules: true
                    ]], 
                    submoduleCfg: [], 
                    userRemoteConfigs: [[
                        credentialsId: 'dengyc', 
                        url: 'https://github.com/deng-yc/DockerTest.git'
                    ]]
                ])
            }        
            stage('编译程序') {

                sh("chmod +x ./build.sh && ./build.sh"); 
                                
            }
            stage('处理yaml'){
                sh 'echo 当前环境为:$DEPLOY_ENV';
                sh 'sed -i "s/##${DEPLOY_ENV}##//g" `grep "##${DEPLOY_ENV}##" -rl deploy/`'
            }
            stage("发布到k8s"){
                kubernetesDeploy(
                    credentialsType: 'Text',
                    textCredentials: [
                        serverUrl: 'https://192.168.31.240:6443',
                        certificateAuthorityData: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNE1ERXpNVEE1TXpneE4xb1hEVEk0TURFeU9UQTVNemd4TjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTnJDCmd6Yjh5cEVoWXRQMlNsckdjOW5ZR3JmY1FzVmQraStBWGtCWDkyd3FwUHhlcWVCQ1laeURkQ3loRjZsb0ZNL3EKZnVmYnVxMXB0dXdiMXMzdGJUcWpHU1hCb1pKMVM2VWZJbHRlbDB1QU5vYWVvVSs3R1dmQkJ0M1Blb2wzSEc3TQpXRnUxdEFBbzBJSytOVjRSY3F1MGk0SGM3dTlGeGJJSkR2WURaeE5ydDk3cTh0OGJOSkt1UDdCMnBkL0pGTkJ2CjlxbGxRNEliV3hxS2lVQzJHRGNVd01jQ2U5azFoTHJQUHhTczBRSFNHNWQ0QTA0RmpNaVBxN0x1THk1YmdPZ1EKZmRwcVhGTVZIOC94UDZXVUZKWWY0dmNBaEk4enl4cmE1NnpENnF0cVNSSldubzV2R3M1Syszd0pYWHhtdEM0cwpNS0Jlam1YRncwYnhwVmQ1M2NNQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFIMTJDVzJEVmhyYnVEOEQ5bmN3T1d4WUhoV1EKc2NUS1NWQlk4NitNL0pSYjFlV2VNQVZudGNCNjV6dTZhQzl3Q01naURacDh5MVVocjZDRDhiajFadW1NcFJhZQpIRlN2WEN3VUhRYUoxWE1OKzNRWFdoOW51Wm0yZU9SRTVaNnFpd0o3RFlWbXYvT3kwWlRKeXRublpOeVV3alpsClBTcHh5SUdYNnRjT1UwbmcwbmRwWVpPVU1NNDV3VFZBZCtCQkJWcERvMlpIQlpFZEUwSFpYeTlBNHlOcnZDd1UKOGI2Nm4xMTYxYnk4bW9RWnZ6ZXFEbGF3aUtycGRsV0VscmVXWmlwTzhEMlU5Vm5OSFF1NVFQemQzU0NpTFFxQQoraUx4RUczRkM3bTYwRWJ0SFl6OFlqb2tFUVBIQzhHd2xkVGFWbEt0a3pFME1yNFdnMVBjb1lqYjNPdz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=',
                        clientCertificateData: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lJRHB0L1lNY2FvYW93RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB4T0RBeE16RXdPVE00TVRkYUZ3MHhPVEF4TXpFd09UTTRNVGhhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXgrcjQwSlNyeGtNSW1nd1YKTjBKdHQ4VFdyeERqdEp6MVJCV2JyYzEvczRFdXowbjRGK3dHZE1YOVlPMEVOa2ErWUdxUmlZMzdUZW5zb0hodQoyRm00cEVZeTY0bk9HdUhwTVI4TWl0TGNzV0hqWVJpQ2ZRcG9MUDYyZnNFUERIb0EvRzk4NGpFTkN3SlNYRHhzCldvRU9xUWtPMTRCcDE1ck9XcWNwZTRWQjY3L3R0dEgzQzd1d2FWU2NyYTVmejB5YlNGY1Q2My8rdkpXWmIzNDYKNTZLR0cxOWNNb0dRWlhKYS9YaGhQUnZna0lLNXcvMGFqSmtRUEw2VlZpYStXL09keXFxdkpzS0oxUEZsV3E4NAp1bWhxSlh1WUNIZEtsUCtBTitIRG8yVzM5S1kxQXMrVEZzUlV5LzY1RWxjYzBuRmVncE5wWURKSDZqSjBCY0loClVTeWp3d0lEQVFBQm95Y3dKVEFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFEYXFqUVppOVBVbnNteUF1eHVxTDZXZ1NDb3Izc0xydUpBawpYMldHRVlyN3Zwb3NJWWUza3JQSWJoanh2cU1KOEhaQ2ZFVHRYWkRZMjFyQjZuQzJBOXViU2lSamlJUk1hZjhCCndnemF4dkZtVDZ0cVJtT1h4dFhNUGpnanQrcnp0d3V1UnM5Z3FVS2t4SHNRYWJ4dGtNaC9GcVBXZDlHSS9TWHUKaXRaSm1nQm1wOW8xVlpqUXZjRnAwM2gwRmNvYUdEOUpmdXZobDlCa3Q2TWY5MEtNV3F3eCt3NFJKUjhuL1UxSwp5eFRpZkwwaElWNVRLK2NjRnJwQzY4cUk4T0tVbk02bWxrZDVsOVhlY2ZsU0RtM3ZkU0pjNGs1NUdrUU0xcHB1ClFaYUt6VHVSTFZIUFNydG5ZL2hhSG0wMVM4dGpMdGh5M2daSUJwTnVjZTNrTjJMdXZjZz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=',
                        clientKeyData: 'LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBeCtyNDBKU3J4a01JbWd3Vk4wSnR0OFRXcnhEanRKejFSQldicmMxL3M0RXV6MG40CkYrd0dkTVg5WU8wRU5rYStZR3FSaVkzN1RlbnNvSGh1MkZtNHBFWXk2NG5PR3VIcE1SOE1pdExjc1dIallSaUMKZlFwb0xQNjJmc0VQREhvQS9HOTg0akVOQ3dKU1hEeHNXb0VPcVFrTzE0QnAxNXJPV3FjcGU0VkI2Ny90dHRIMwpDN3V3YVZTY3JhNWZ6MHliU0ZjVDYzLyt2SldaYjM0NjU2S0dHMTljTW9HUVpYSmEvWGhoUFJ2Z2tJSzV3LzBhCmpKa1FQTDZWVmlhK1cvT2R5cXF2SnNLSjFQRmxXcTg0dW1ocUpYdVlDSGRLbFArQU4rSERvMlczOUtZMUFzK1QKRnNSVXkvNjVFbGNjMG5GZWdwTnBZREpINmpKMEJjSWhVU3lqd3dJREFRQUJBb0lCQUErMmdTM3JzWUNZdmpGVgpaOGw3R0NLTWZ3OHRkYWc1ZWZHSy9UeHczV3VmYUsxME0rSzFjMkIwTzFFRjhBSFFGNkIrWDhmKzk5U000VU5QCmsrNi9Sb3JxMVkrN3VnNVUyVDQ2SVlNN3hZclBsYzZJM2FDMFU3SE5wMHhaSWpTcDFqQUJGMEN6K0VGNFFqN3IKcE55TUxqbk04M1N1ckNMOUVPRUJLSHFENDhXQ29iemZEK2xtazd4cHVLY1hPY2liZEpWR2svYk9MZmU1SndZegpQR3ZNRnREeEZKbWcyeSs5YXdYRmJZZWdjOCt0S283b1RnS005b21CSG9lMEVOem1vMEN1b1VKdkl5SzI1VFMxCnh5OCtLSG9wSHRkc1Y0aE1tdExoMjJMS2pLMWpab0pyV2RBNy90T25kQ0tlZW1hTkZlWlk4NWNZNDJYWDllVk0KTDA5YzNFa0NnWUVBNVB3VWMxRjNiODdIRmFlRXowcjlOR29SS0hZUjNzd0dVU3RSbWZkN0k2SW1pZnFuNDErSgpGYjk1Wkp0SXNmdzg3dmgyYkdCQmdwZHdybDNCVVJEdVA4VGVySGtJcitPb253SG5DSkUySTF3WGMzKzBoY2dFCjlaN094TzY1YUszV3dvUE5GczhHMk9iUUIwWVFqeGVzOXpyVHZjSTJqVjUyRTRwOEVwbEl0OVVDZ1lFQTM0RC8KK1JnR1JWTmNhK1hRZGRZenp6TXphM2JwL0hXWklxQm5KTEJRbXJzNlBFcGRpV2l1MWc1UDdvUE92S21ZT3pYdwpTNGNZQ0pQNTlYRUpOUHhTaXRYWDEzeW5QRTNyL1pVRW9LRUEvU3FmWWtoOW83Z01iVTBNNnhlVDFaM0hwa3FpClFhZnEyeStSYUVvVlRRVVh4cTVWdzhTNWpmcWxlb0xTN0pqNEVUY0NnWUIrM040anFhM25Sd05yanR6NHo4NEsKdlB6MmtydUIyVDFpdVFKRHNDWUw3dWsxSnFiZlJPMjVHOVVRbFN1b1dGd1Y5WmYrb1RHS1BZYlRRK1EzbW82MAp5OGltZTRRQmxycTBKYVN2VFd4V0dNNXhVZjVjNUIxRFM1RzQ3NTNQVGdpZXlkRFZZeXVpL2ZXaElnTklrOUJqClJMZE0rWTJwc3Z6dUJKcUszMXUzWlFLQmdRQ0U4VEJRdEErVzBOemFlUm9qM1VOMzdaYWFSMk1xZmJDV3ZoNWIKM2x3empVWTRjbXRzdmsyd21WYkdJclNuMTZEckoweEZRSmYxRWovTjFHeUxqY0p6UG50aWU0emwrOXR4UEdCQwpRMEpaVkM3MXdQU3FtMkVZNm9uU2xIV2t6SExpNE9YZWM4am9rMFRFYWJ4OTBaZXc0Q1czaXA1c2F6aGV4TTQ5CldVZkV4UUtCZ1FDeWdhRjYxcWEreW0vRjZlQzVqVWxDekg4TStFdFVvMlpXN0ZLTUxPQnh1OGswVDNyam8zR3gKUENNTkdMOWtuMGdIZG1YNjNoVzZJMm9CSHVWYkpTZFVSY0JwZjVRczhFSTQ0dSs5TVRiVTRBVnh2Vkpjd2VpUgptTzBhMDdVMjlSbG9wRjMxeCtZUjJwNEVGVGEzL1lSUGN4UmZlV0Q5QnhPeU90Rk1CN0N0OXc9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=',
                    ],
                    configs:"deploy/**/*.yaml",
                    enableConfigSubstitution:true
                )
            }
        }
    }
}