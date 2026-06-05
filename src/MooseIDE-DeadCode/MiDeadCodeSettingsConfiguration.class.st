Class {
	#name : 'MiDeadCodeSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'deleteLines'
	],
	#category : 'MooseIDE-DeadCode-Model',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> deleteLines [

	^ deleteLines
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> deleteLines: anObject [

	deleteLines := anObject
]

{ #category : 'ui' }
MiDeadCodeSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection with: ((MiBooleanSettingPresenter on: self)
			   label: 'Delete line of code' ;
			   help: 'To remove dead entities, delete lines of code or comment them out.' ;
			   state: deleteLines ;
			   whenStateChangedDo: [ :boolean | self deleteLines: boolean ] ;
			   yourself)
]
