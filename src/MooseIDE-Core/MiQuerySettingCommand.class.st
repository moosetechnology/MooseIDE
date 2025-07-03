Class {
	#name : #MiQuerySettingCommand,
	#superclass : #MiSettingCommand,
	#instVars : [
		'initialQuery',
		'defaultQuery',
		'items',
		'initialSelectedItem',
		'displayAction'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiQuerySettingCommand class >> defaultDisplayAction [

	^ [ :query | query displayString ]
]

{ #category : #default }
MiQuerySettingCommand class >> defaultItems [
	"Override to set a collection as default items"

	| defaultQueries aMiQuerySettingBuilder |
	aMiQuerySettingBuilder := self new.
	defaultQueries := OrderedCollection withAll:
		                  (MiApplication current itemsFor: FQAbstractQuery).
	aMiQuerySettingBuilder class defaultInitialValue ifNotNil: [ :query |
		defaultQueries addFirst: query ].

	^ defaultQueries
]

{ #category : #'as yet unclassified' }
MiQuerySettingCommand class >> defaultPresenterClass [

	^ SpDropListPresenter
]

{ #category : #building }
MiQuerySettingCommand >> buildPresenter [

	^ super buildPresenter
		  items: self items;
		  selectItem: self currentValue;
		  display: [ :item | self displayAction cull: item ];
		  whenSelectedItemChangedDo: [ :selectedItem |
			  self action cull: selectedItem ];
		  yourself
]

{ #category : #accessing }
MiQuerySettingCommand >> displayAction [

	^ displayAction ifNil: [ self class defaultDisplayAction ]
]

{ #category : #accessing }
MiQuerySettingCommand >> items [

	^ items ifNil: [ self class defaultItems ]
]
