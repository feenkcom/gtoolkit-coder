Class {
	#name : #GtPackageTagCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packageTagCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildClassesList [
	^ packageTagCoder classesCoder asElement
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildContentPane [
	self removeChildren.
	self addChild: self buildPackageTagLabel.
	self addChild: self buildParentLink.
	self addChild: self buildClassesList
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildPackageTagLabel [
	| tagNameEditor container previewButton |
		
	container := BrHorizontalPane new
		hMatchParent;
		alignCenterLeft;
		vFitContent.
	
	tagNameEditor := BrEditableLabel new
		look: (BrGlamorousEditableLabelLook new
			defaultBackground: Color transparent;
			glamorousCodeFont;
			bold;
			fontSize: 18);
		inputFilter: BrTextEditorAlphaNumericInputFilter new;
		text: packageTagCoder packageTag name;
		margin: (BlInsets all: 0).

	previewButton := GtRefactoringsPreviewButton new
		margin: (BlInsets left: 5);
		visibility: BlVisibility hidden;
		refactorings: [ { RBRenamePackageTagRefactoring packageName: packageTagCoder package name from: packageTagCoder packageTag name to: tagNameEditor text asString } ];
		when: GtRefactoringsAppliedEvent do: [ :anEvent | anEvent currentTarget visibility: BlVisibility hidden ].
		
	tagNameEditor editor
		when: BrTextEditorModifiedEvent 
		do: [ :anEvent |
			anEvent text asString = packageTagCoder packageTag name
				ifTrue: [ previewButton visibility: BlVisibility hidden ]
				ifFalse: [  previewButton visibility: BlVisibility visible ] ].

	container addChild: tagNameEditor.
	container addChild: previewButton.

	^ container
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildParentLink [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout new beHorizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: BrGlamorousLabelLook new glamorousRegularFont;
				text: 'In: ').
	element
		addChild:
			(BrButton new
				look:
					(BrGlamorousButtonExteriorLook new borderPaint: Color transparent)
						+ BrGlamorousLabelLook new glamorousRegularFont;
				label: packageTagCoder package name;
				action: [
					| anEvent |

					anEvent := (GtCoderToReplace new coder: packageTagCoder packageCoder).
					self fireEvent: anEvent.

					anEvent isConsumed
						ifFalse: [ self phlow spawnObject: anEvent coder ] ]).
	^ element
]

{ #category : #initialization }
GtPackageTagCoderElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 5 left: 6 bottom: 5 right: 6).
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder [
	^ packageTagCoder
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder: anObject [
	packageTagCoder := anObject.
	self buildContentPane
]
