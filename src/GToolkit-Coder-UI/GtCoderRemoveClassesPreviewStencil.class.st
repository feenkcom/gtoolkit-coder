Class {
	#name : #GtCoderRemoveClassesPreviewStencil,
	#superclass : #BrStencil,
	#instVars : [
		'classesToRemove',
		'menuModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> classesToRemove [
	^ classesToRemove
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> classesToRemove: anObject [
	classesToRemove := anObject
]

{ #category : #'as yet unclassified' }
GtCoderRemoveClassesPreviewStencil >> create [
	| element change button |
	element := BrVerticalPane new fitContent.
	element
		addChild: (self newRemoveSeveralClassesLabel
				margin: (BlInsets
						top: 10
						bottom: 0
						left: 10
						right: 10)).
	element
		addChild: (BrAsyncWidget new
				fitContent;
				stencil: [ | pane references subclasses |
					references := self classesToRemove
							sumNumbers: [ :eachClass | (GtPharoIndex current globalVariableReferencesTo: eachClass binding) size ].
					subclasses := self classesToRemove
							sumNumbers: [ :eachClass | (eachClass allSubclasses difference: self classesToRemove) size ].
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
					pane ]).
	change := RBCompositeRefactoryChange new
			name: ('Remove {1} classes' format: {self classesToRemove size});
			changes: (self classesToRemove
					collect: [ :eachClass | RBRemoveClassChange remove: eachClass ]).
	button := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			beSmallSize;
			margin: (BlInsets
					top: 10
					bottom: 10
					left: 10
					right: 10);
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			action: [ self menuModel ifNotNil: #hideAll.
				change execute ].
	element addChild: button as: #removeButton.
	^ element
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> menuModel [
	^ menuModel
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> menuModel: anObject [
	menuModel := anObject
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newRemoveSeveralClassesLabel [
	| labelText |
	labelText := 'Remove {1} classes' format: {self classesToRemove size}.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]
