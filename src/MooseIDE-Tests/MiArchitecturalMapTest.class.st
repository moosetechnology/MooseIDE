Class {
	#name : #MiArchitecturalMapTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiArchitecturalMapTest >> architecturalMapWith: entities [

	| mockModel mockBrowser |
	
	"mock MiArchitecturalMapModel with proper settings and MooseEntities"
	mockModel:= Mock named: 'MiArchitecturalMapModel'.
	mockModel stub showBusEntities willReturn: true.
	mockModel stub showAllLinks willReturn: false.
	mockModel stub tags willReturn: #().
	mockModel stub entities willReturn: entities.

	"Mock MiArchitecturalMapBrowser with model -> mockModel"
	mockBrowser := Mock named: 'MiArchitecturalMapBrowser'.
	mockBrowser stub model willReturn: mockModel.

	"MiArchitecturalMap with owner -> mockBrowser"
	^MiArchitecturalMapVisualization new
		owner: mockBrowser

]

{ #category : #tests }
MiArchitecturalMapTest >> testShapeFromEntity [
	| map entity |
	entity := FamixStClass named: 'anEntity'.
	map := self architecturalMapWith: { FamixStClass named: 'entity2' . entity }.
	map run.

	self assert: (map shapeFromEntity: entity) notNil.
	self assert: (map shapeFromEntity: (FamixStClass named: 'entity3')) isNil
]
