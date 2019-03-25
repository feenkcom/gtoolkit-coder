Class {
	#name : #GtCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'coder',
		'innerContainer'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderElement >> buildContent [
	| selectorElement packagesTree |
	selectorElement := self coderModel searchFilter asElement.
	self addChild: selectorElement.
	
	innerContainer := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: innerContainer.
	
	packagesTree := self buildPackagesTree.
	packagesTree padding: (BlInsets all: 10).
	packagesTree constraintsDo: [ :c |
		c linear weight: 1 ].
	innerContainer addChild: packagesTree.
	
	self coderModel classCoder ifNotNil: [ :aClassCoder |
		| classPackage classCoderElement | 
		classPackage := aClassCoder theClass package.
		packagesTree viewModel root childrenNodes
			detect: [ :each | each value = classPackage ]
			ifFound: [ :aTreeNode |
				aTreeNode isExpanded ifFalse: [ aTreeNode expand ] ].
		
		classCoderElement := aClassCoder asElement.
		classCoderElement constraintsDo: [ :c |
			c linear weight: 2 ].
		innerContainer addChild: classCoderElement ]
]

{ #category : #accessing }
GtCoderElement >> buildPackagesTree [
	| tree |
	tree := BrColumnedTree new.
	tree 
		items: (RPackageOrganizer default packages sort: [ :a :b | a name < b name ])
		children: [ :anObject | (anObject isKindOf: RPackage) 
			ifTrue: [ anObject definedClasses ] 
			ifFalse: [ #() ] ].
	tree column
		stencil: [ :anObject | BrColumnCellLabelStencil new text: anObject value name ].
	tree when: BrSelectionChanged do: [ :anEvent |
		anEvent selectedDo: [ :anInterval | 
			tree selectedNodeDo: [  :aNode | 
				aNode value isClass ifTrue: [ 
					self coderModel selectClass: aNode value ] ] ] ].
	^ tree
]

{ #category : #accessing }
GtCoderElement >> coderModel [
	^ coder
]

{ #category : #accessing }
GtCoderElement >> coderModel: aCoder [
	coder := aCoder.
	coder
		when: GtCoderClassSelectedAnnouncement
		do: [ :ann | self updateClassCoderElement ].
	self buildContent.
]

{ #category : #initialization }
GtCoderElement >> initialize [ 
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #accessing }
GtCoderElement >> innerContainer [
	^ innerContainer
]

{ #category : #updating }
GtCoderElement >> updateClassCoderElement [
	| classCoder |
	classCoder := self coderModel classCoder.
	[ self innerContainer childrenCount > 1 ] whileTrue: [ self innerContainer removeChildAt: 2 ].
	self innerContainer addChild: classCoder asElement
]
