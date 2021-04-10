Class {
	#name : #MiModelUtilityCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #converting }
MiModelUtilityCommand class >> asCommandGroupWith: aPresenter [
	| exportCommandGroup |
	exportCommandGroup := CmCommandGroup forSpec
		name: self defaultName;
		description: self defaultDescription.
	self
		allSubclassesDo: [ :cmd | 
			exportCommandGroup
				register: ((cmd forSpecContext: aPresenter) iconName: cmd defaultIconName) ].
	^ exportCommandGroup
]

{ #category : #default }
MiModelUtilityCommand class >> defaultDescription [
	^ 'Utility'
]

{ #category : #defaults }
MiModelUtilityCommand class >> defaultIconName [
	^ #blank
]

{ #category : #default }
MiModelUtilityCommand class >> defaultName [
	^ 'Utility'
]

{ #category : #testing }
MiModelUtilityCommand >> canBeExecuted [
	^ self model isMooseModel
]

{ #category : #accessing }
MiModelUtilityCommand >> model [
	^ self context miSelectedItem
]
