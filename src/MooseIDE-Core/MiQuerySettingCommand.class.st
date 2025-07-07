Class {
	#name : #MiQuerySettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiQuerySettingCommand class >> availableQueries [

	^ OrderedCollection withAll:
		  (MiApplication current itemsFor: FQAbstractQuery)
]

{ #category : #specs }
MiQuerySettingCommand class >> presenterClass [

	^ SpDropListPresenter
]

{ #category : #building }
MiQuerySettingCommand >> buildPresenter [

	^ super buildPresenter
		  items: self queries;
		  selectItem: self currentValue;
		  display: [ :query | query name ];
		  whenSelectedItemChangedDo: [ :selectedItem |
			  self execute: selectedItem ];
		  yourself
]

{ #category : #'as yet unclassified' }
MiQuerySettingCommand >> defaultQuery [

	^ nil
]

{ #category : #accessing }
MiQuerySettingCommand >> queries [

	| availableQueries |
	availableQueries := self class availableQueries.

	self defaultQuery ifNotNil: [ :query |
		availableQueries addFirst: query ].

	^ availableQueries
]
