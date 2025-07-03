Class {
	#name : #MiBooleanSettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiBooleanSettingCommand class >> defaultInitialValue [
	"Override to set a default value. Used to reset settings"

	^ true
]

{ #category : #'as yet unclassified' }
MiBooleanSettingCommand class >> defaultPresenterClass [

	^ SpCheckBoxPresenter
]

{ #category : #building }
MiBooleanSettingCommand >> buildPresenter [

	^ super buildPresenter
		  state: self currentValue;
		  whenChangedDo: [ :specState | self execute: specState ];
		  yourself
]
