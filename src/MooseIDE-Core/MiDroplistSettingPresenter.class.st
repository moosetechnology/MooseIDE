Class {
	#name : 'MiDroplistSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'droplist'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'layout' }
MiDroplistSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: droplist;
		  yourself
]

{ #category : 'api' }
MiDroplistSettingPresenter >> display: aBlock [

	droplist display: aBlock
]

{ #category : 'initialization' }
MiDroplistSettingPresenter >> initializePresenters [

	droplist := self newDropList
]

{ #category : 'accessing' }
MiDroplistSettingPresenter >> items: aCollection [

	droplist items: aCollection
]

{ #category : 'api - selection' }
MiDroplistSettingPresenter >> selectItem: anObject [

	droplist selectItem: anObject
]

{ #category : 'api' }
MiDroplistSettingPresenter >> whenSelectedDo: aBlock [

	droplist whenSelectedItemChangedDo: aBlock
]
