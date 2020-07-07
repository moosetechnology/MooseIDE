Class {
	#name : #MiRoassalQueryPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-Widgets'
}

{ #category : #running }
MiRoassalQueryPresenterTest >> browserWithSimilarQueries [
	| browser query1 query2 query3 query4 |
	browser := MiQueriesBrowser
		on:
			(FQRootQuery new
				result: helper classesAndMethods;
				yourself).
	query1 := (FQTypeQuery new type: FamixStClass)
		beChildOf: browser initialQuery.
	query2 := (FQTypeQuery new type: FamixStMethod)
		beChildOf: browser initialQuery.
	query3 := (FQBooleanQuery new property: #isAbstract)
		beChildOf: query1.
	query4 := (FQBooleanQuery new property: #isAbstract)
		beChildOf: query2.
	{query1.
	query2.
	query3.
	query4} do: [ :query | browser updateForQuery: query ].
	^ browser
]

{ #category : #running }
MiRoassalQueryPresenterTest >> classToTest [
	^ MiRoassalQueryPresenter
]

{ #category : #running }
MiRoassalQueryPresenterTest >> setUp [
	super setUp.
	helper := FQTestsHelper current
]

{ #category : #tests }
MiRoassalQueryPresenterTest >> testPointingOnlyToActualChildren [
	| browser presenter |
	browser := self browserWithSimilarQueries.
	presenter := (self classToTest on: browser queries)
		adaptToBrowser: browser.
	[ presenter openWithSpec.
	presenter canvas nodes
		do: [ :box | self assert: box incomingEdges size < 2 ] ]
		ensure: [ presenter window close ]
]
