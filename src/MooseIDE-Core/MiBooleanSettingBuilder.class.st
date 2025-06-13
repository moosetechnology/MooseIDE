Class {
	#name : #MiBooleanSettingBuilder,
	#superclass : #MiAbstractSettingBuilder,
	#instVars : [
		'initialValue',
		'defaultValue'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'as yet unclassified' }
MiBooleanSettingBuilder class >> defaultPresenterClass [

	^ SpCheckBoxPresenter
]

{ #category : #accessing }
MiBooleanSettingBuilder >> currentValue [

	^ self defaultCurrentValue ifNil: [ self initialValue ]
]

{ #category : #default }
MiBooleanSettingBuilder >> defaultCurrentValue [
	"Override to set a way to get the current value, 
	i.e. get it from the settings manager"

	^ nil
]

{ #category : #default }
MiBooleanSettingBuilder >> defaultInitialValue [
	"Override to set a default value. Used to reset settings"

	^ true
]

{ #category : #accessing }
MiBooleanSettingBuilder >> initialValue [

	^ initialValue ifNil: [ self defaultInitialValue ]
]

{ #category : #accessing }
MiBooleanSettingBuilder >> initialValue: aBoolean [

	initialValue := aBoolean
]

{ #category : #building }
MiBooleanSettingBuilder >> initializePresenter [

	^ super initializePresenter
		  state: self currentValue;
		  whenChangedDo: [ :specState | self action cull: specState ];
		  yourself
]
