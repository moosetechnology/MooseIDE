Class {
	#name : #MiButtonListSettingItem,
	#superclass : #MiButtonSettingItem,
	#instVars : [
		'updateBlock'
	],
	#category : #'MooseIDE-Core-Settings'
}

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
