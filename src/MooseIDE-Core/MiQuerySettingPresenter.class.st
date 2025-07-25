Class {
	#name : #MiQuerySettingPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'droplist'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'as yet unclassified' }
MiQuerySettingPresenter >> beForChildren [

	self
		label: 'Children query';
		help: 'Query used to get the children of an entity'.

	droplist
		items: (droplist items
				 addFirst: self application defaultChildrenQuery;
				 yourself);
		selectItem: memento childrenQuery;
		whenSelectedItemChangedDo: [ :query | memento childrenQuery: query ]
]

{ #category : #'as yet unclassified' }
MiQuerySettingPresenter >> beForClients [

	self
		label: 'Clients query';
		help: 'Query used to get the clients of an entity, i.e. dependencies to this entity'.

	droplist
		items: (droplist items
				 addFirst: self application defaultClientsQuery;
				 yourself);
		selectItem: memento clientsQuery;
		whenSelectedItemChangedDo: [ :query | memento clientsQuery: query ]
]

{ #category : #'as yet unclassified' }
MiQuerySettingPresenter >> beForProviders [

	self
		label: 'Providers query';
		help: 'Query used to get the providers of an entity, i.e. dependencies from this entity'.

	droplist
		items: (droplist items
				 addFirst: self application defaultProvidersQuery;
				 yourself);
		selectItem: memento providersQuery;
		whenSelectedItemChangedDo: [ :query | memento providersQuery: query ]
]

{ #category : #layout }
MiQuerySettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  add: droplist;
		  yourself
]

{ #category : #initialization }
MiQuerySettingPresenter >> initializePresenters [

	droplist := self newDropList
		            items: self application availableQueries;
		            display: [ :query | query name ];
		            yourself
]
