Class {
	#name : #MiButtonListSettingItem,
	#superclass : #MiButtonSettingItem,
	#instVars : [
		'updateBlock'
	],
	#category : #'MooseIDE-Core-Settings-old'
}

{ #category : #accessing }
MiButtonListSettingItem >> display: aBlock [

	secondaryPresenter display: aBlock
]

{ #category : #accessing }
MiButtonListSettingItem >> displayIcon: aBlock [

	secondaryPresenter displayIcon: aBlock
]

{ #category : #updating }
MiButtonListSettingItem >> possibleValues: aList [

	self subclassResponsibility 
]

{ #category : #updating }
MiButtonListSettingItem >> update [

	updateBlock ifNil: [ ^ self ].
	self possibleValues: updateBlock value
]

{ #category : #updating }
MiButtonListSettingItem >> updateWith: aBlock [

	updateBlock := aBlock
]
