Class {
	#name : #MiMegamorphicInvocationsSettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiMegamorphicInvocationsSettingCommand class >> defaultDescription [

	^ 'Hide invocations if they have more than a specified number of candidates. Examples: #new, #add:'
]

{ #category : #default }
MiMegamorphicInvocationsSettingCommand class >> defaultName [

	^ 'Hide megamorphic invocations'
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingCommand >> currentState [

	^ self context hideMegamorphicInvocations
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingCommand >> currentTreshold [

	^ self context megamorphicTreshold
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingCommand >> presenterClass [

	^ MiMegamorphicInvocationsSettingPresenter
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingCommand >> state: aBoolean [

	self context hideMegamorphicInvocations: aBoolean
]

{ #category : #accessing }
MiMegamorphicInvocationsSettingCommand >> treshold: aNumber [

	self context megamorphicTreshold: aNumber
]
