Class {
	#name : #MiDuplicationSettingsConfiguration,
	#superclass : #MiAbstractSettingsConfiguration,
	#instVars : [
		'maximumShownReplicas',
		'sourcesCleaner',
		'minimumNumberOfReplicas',
		'minimumNumberOfCharacters',
		'minimumNumberOfLines',
		'availableSourceCleaners'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> availableSourceCleaners [

	^ availableSourceCleaners
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> availableSourceCleaners: aCollection [

	availableSourceCleaners := aCollection
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> maximumShownReplicas [

	^ maximumShownReplicas
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> maximumShownReplicas: anObject [

	maximumShownReplicas := anObject
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfCharacters [

	^ minimumNumberOfCharacters
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfCharacters: anObject [

	minimumNumberOfCharacters := anObject
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfLines [

	^ minimumNumberOfLines
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfLines: anObject [

	minimumNumberOfLines := anObject
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfReplicas [

	^ minimumNumberOfReplicas
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> minimumNumberOfReplicas: anObject [

	minimumNumberOfReplicas := anObject
]

{ #category : #ui }
MiDuplicationSettingsConfiguration >> settingsPresenters [

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

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> sourcesCleaner [

	^ sourcesCleaner
]

{ #category : #accessing }
MiDuplicationSettingsConfiguration >> sourcesCleaner: anObject [

	sourcesCleaner := anObject
]
