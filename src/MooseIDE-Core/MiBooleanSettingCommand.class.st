Class {
	#name : #MiBooleanSettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'as yet unclassified' }
MiBooleanSettingCommand class >> presenterClass [

	^ SpCheckBoxPresenter
]

{ #category : #building }
MiBooleanSettingCommand >> buildPresenter [

	^ super buildPresenter
		  state: self currentValue;
		  whenChangedDo: [ :specState | self execute: specState ];
		  yourself
]
