"
Handler of settings for MiAPIBrowser
"
Class {
	#name : 'MiAPIBrowserSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'accessedPrefix',
		'clientPrefix'
	],
	#category : 'MooseIDE-API-Browser-settings',
	#package : 'MooseIDE-API-Browser',
	#tag : 'settings'
}

{ #category : 'accessing' }
MiAPIBrowserSettingsConfiguration >> accessedPrefix [

	^ accessedPrefix
]

{ #category : 'accessing' }
MiAPIBrowserSettingsConfiguration >> accessedPrefix: anObject [

	accessedPrefix := anObject
]

{ #category : 'accessing' }
MiAPIBrowserSettingsConfiguration >> clientPrefix [

	^ clientPrefix
]

{ #category : 'accessing' }
MiAPIBrowserSettingsConfiguration >> clientPrefix: anObject [

	clientPrefix := anObject
]

{ #category : 'ui' }
MiAPIBrowserSettingsConfiguration >> settingsPresenters [

	^{
	(MiTextFieldSettingPresenter on: self)
		label: 'Provider prefix' ;
	   help: 'The prefix name of accessed entities
ex: the fully qualified name of a package.' ;
		text: self accessedPrefix ;
	   whenTextChangedDo: [ :txt | self accessedPrefix: txt ] ;
		yourself
	.
	(MiTextFieldSettingPresenter on: self)
		label: 'Client prefix' ;
	   help: 'The prefix name of client entities
ex: the fully qualified name of a package.' ;
		text: self clientPrefix ;
	   whenTextChangedDo: [ :txt | self clientPrefix: txt ] ;
		yourself
	}
]
