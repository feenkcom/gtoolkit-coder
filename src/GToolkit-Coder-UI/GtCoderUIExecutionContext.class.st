Class {
	#name : #GtCoderUIExecutionContext,
	#superclass : #GtCoderExecutionContext,
	#instVars : [
		'spaceId'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'gt-extensions' }
GtCoderUIExecutionContext >> gtSpacePreviewFor: aView [
	<gtView>
	| aSpace |
	BlSpace
		spaceWithId: self spaceId
		do: [ :theSpace | aSpace := theSpace ].
	aSpace ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Space Preview';
		priority: 1;
		object: [ aSpace ];
		view: #gtPreviewFor:
]

{ #category : #'api - accessing' }
GtCoderUIExecutionContext >> spaceDo: aBlock [
	^ BlSpace
		spaceWithId: self spaceId
		do: aBlock
]

{ #category : #'api - accessing' }
GtCoderUIExecutionContext >> spaceId [
	<return: #Integer>
	^ spaceId
]

{ #category : #'api - accessing' }
GtCoderUIExecutionContext >> spaceId: anInteger [
	spaceId := anInteger
]
