Class {
	#name : #GtCoderRemoveClassPreviewStencil,
	#superclass : #BrStencil,
	#instVars : [
		'classToRemove',
		'menuModel'
	],
	#category : 'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classToRemove [
	^ classToRemove
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classToRemove: anObject [
	classToRemove := anObject
]

{ #category : #'api - instantiation' }
GtCoderRemoveClassPreviewStencil >> create [
	| element change button |
	element := BrVerticalPane new fitContent.
	element
		addChild: (self newRemoveClassLabel
				margin: (BlInsets
						top: 10
						bottom: 0
						left: 10
						right: 10)).
	element addChild: self newReferencesAsyncElement.
	change := RBRemoveClassChange remove: self classToRemove.
	button := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			beSmallSize;
			margin: (BlInsets
					top: 10
					bottom: 10
					left: 10
					right: 10);
			icon: BrGlamorousVectorIcons bin;
			label: 'Remove';
			action: [ self menuModel ifNotNil: #hideAll.
				change execute ].
	element addChild: button as: #removeButton.
	^ element
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> menuModel [
	^ menuModel
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> menuModel: anObject [
	menuModel := anObject
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newReferencesAsyncElement [
	^ BrAsyncWidget new
		fitContent;
		stencil: [ self newReferencesContentElement ]
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newReferencesContentElement [
	| pane users references subclasses |
	references := (GtPharoIndex current
			globalVariableReferencesTo: self classToRemove binding) size.
	subclasses := self classToRemove allSubclasses size.
	users := self classToRemove isTrait
			ifFalse: [ 0 ]
			ifTrue: [ self classToRemove users size ].
	pane := BrVerticalPane new.
	pane fitContent.
	references > 0
		ifTrue: [ pane
				addChild: (BrLabel new
						margin: (BlInsets left: 10 right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
						text: (references printString , ' reference'
								, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
	subclasses > 0
		ifTrue: [ pane
				addChild: (BrLabel new
						margin: (BlInsets left: 10 right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
						text: (subclasses printString , ' subclass'
								, (subclasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ])) asRopedText) ].

	users > 0
		ifTrue: [ pane
				addChild: (BrLabel new
						margin: (BlInsets left: 10 right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
						text: (users printString , ' user' , (users > 1 ifTrue: [ 's' ] ifFalse: [ '' ]))
								asRopedText) ].
	^ pane
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newRemoveClassLabel [
	| labelText |
	labelText := 'Remove {1} {2}' format: { self classToRemove gtCoderTypeName. self classToRemove name }.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]
