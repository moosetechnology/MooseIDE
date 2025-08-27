Class {
	#name : 'MiDuplicationMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'maximumShownReplicas',
		'sourcesCleaner',
		'minimumNumberOfReplicas',
		'minimumNumberOfCharacters',
		'minimumNumberOfLines',
		'availableSourceCleaners'
	],
	#category : 'MooseIDE-Duplication',
	#package : 'MooseIDE-Duplication'
}

{ #category : 'accessing' }
MiDuplicationMemento >> availableSourceCleaners [

	^ availableSourceCleaners
]

{ #category : 'accessing' }
MiDuplicationMemento >> availableSourceCleaners: aCollection [

	availableSourceCleaners := aCollection
]

{ #category : 'accessing' }
MiDuplicationMemento >> maximumShownReplicas [

	^ maximumShownReplicas
]

{ #category : 'accessing' }
MiDuplicationMemento >> maximumShownReplicas: anObject [

	maximumShownReplicas := anObject
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfCharacters [

	^ minimumNumberOfCharacters
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfCharacters: anObject [

	minimumNumberOfCharacters := anObject
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfLines [

	^ minimumNumberOfLines
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfLines: anObject [

	minimumNumberOfLines := anObject
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfReplicas [

	^ minimumNumberOfReplicas
]

{ #category : 'accessing' }
MiDuplicationMemento >> minimumNumberOfReplicas: anObject [

	minimumNumberOfReplicas := anObject
]

{ #category : 'ui' }
MiDuplicationMemento >> settingsPresenters [

	^ OrderedCollection new
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Minimum number of lines for a replica';
				   help:
					   'Minimum number of lines of code in a duplicated fragment.
The larger, the less duplicated snippets found.';
				   number: self minimumNumberOfLines;
				   whenNumberChangedDo: [ :nb | self minimumNumberOfLines: nb ];
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Minimum number of characters for a replica';
				   help: 'Minimum number of characters in a duplicated fragment.
Code fragments that are too small are not interesting.';
				   number: self minimumNumberOfCharacters;
				   whenNumberChangedDo: [ :nb |
					   self minimumNumberOfCharacters: nb ];
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Minimum number of replicas';
				   help: 'Minimum number of times a fragment is duplicated.
The larger, the less duplicated snippets found.
Minimum: 2';
				   number: self minimumNumberOfReplicas;
				   minimum:
					   MiDuplicationBrowserModel defaultMinimumNumberOfReplicas;
				   whenNumberChangedDo: [ :nb | self minimumNumberOfReplicas: nb ];
				   yourself);
		  add: (MiCodeCleanerSettingPresenter on: self);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Maximum number of shown replicas';
				   help: 'Maximum number of replicas shown in the browser.
If a fragment is duplicated many times, the browser will only show that maximum number of occurences';
				   number: self maximumShownReplicas;
				   whenNumberChangedDo: [ :nb | self maximumShownReplicas: nb ];
				   yourself);
		  yourself
]

{ #category : 'accessing' }
MiDuplicationMemento >> sourcesCleaner [

	^ sourcesCleaner
]

{ #category : 'accessing' }
MiDuplicationMemento >> sourcesCleaner: anObject [

	sourcesCleaner := anObject
]
