Class {
	#name : #GtBaselineCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'baselines'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtBaselineCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| string completionActions first name classes last ch deleteAction |
	string := aText asString.
	first := positionInteger.
	[ first > 0 and: [ (string at: first) ~= $' ] ]
		whileTrue: [ first := first - 1 ].
	first = 0
		ifTrue: [ ^ #() ].
	name := 'BaselineOf'
		, (string copyFrom: first + 1 to: positionInteger).
	classes := BaselineOf withAllSubclasses
		select: [ :each | each name beginsWith: name ].
	classes isEmpty
		ifTrue: [ ^ #() ].
	last := positionInteger.
	[ last <= string size
		and: [ (ch := string at: last) isSeparator not and: [ ch ~= $' ] ] ]
		whileTrue: [ last := last + 1 ].
	last - 1 > positionInteger
		ifTrue: [ deleteAction := GtDeleteTextCompletionAction
				labeled: ''
				from: positionInteger + 1
				to: last - 1 ].
	completionActions := (classes
		asSortedCollection: [ :a :b | a name < b name ])
		collect: [ :each | 
			| insert |
			insert := GtInsertTextCompletionAction
				labeled: (each name allButFirst: 10)
				completion: (each name allButFirst: name size)
				position: positionInteger
				from: positionInteger - name size + 1.
			deleteAction isNil
				ifTrue: [ insert ]
				ifFalse: [ (GtCompositeCompletionAction labeled: insert label)
						addAction: deleteAction;
						addAction: insert;
						yourself ] ].
	^ completionActions
]

{ #category : #testing }
GtBaselineCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
