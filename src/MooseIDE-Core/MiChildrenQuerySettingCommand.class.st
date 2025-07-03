Class {
	#name : #MiChildrenQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultAction [

	^ [ :query | manager childrenQuery: query ]
]

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the children of an entity'
]

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultDisplayAction [

	^ [ :query | query name ]
]

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultInitialValue [

	^ (FQCollectScriptQuery script: [ :each | each children ])
		  name: 'anEntity children';
		  yourself
]

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultName [

	^ 'Children query'
]
