Class {
	#name : #MiDuplicationSettingsBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'settingModel',
		'settingBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDuplicationSettingsBrowserTest >> clickOnButton: aButton [
	[ aButton click] on: MessageNotUnderstood do: [ :event |
		(event message selector = #close) ifFalse: [self fail: event messageText ]
		"else raised because settingBrowser has no window: ignore" ].
]

{ #category : #running }
MiDuplicationSettingsBrowserTest >> setUp [
	super setUp.
	
	settingModel := MiDuplicationBrowserSettings new.
	settingBrowser := MiDuplicationSettingsBrowser on: settingModel.
]

{ #category : #tests }
MiDuplicationSettingsBrowserTest >> testAbortSettings [
	settingModel minNumberOfReplicas: 2.
	
	settingBrowser txtNumberOfReplicas text: '15'.
	self clickOnButton: settingBrowser btnCancel.

	self assert: settingModel minNumberOfReplicas equals: 2

]

{ #category : #tests }
MiDuplicationSettingsBrowserTest >> testAcceptSettings [
	settingModel minNumberOfReplicas: 2.
	
	settingBrowser txtNumberOfReplicas text: '15'.
	self clickOnButton: settingBrowser btnOk.

	self assert: settingModel minNumberOfReplicas equals: 15

]
