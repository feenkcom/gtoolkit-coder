Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'ui building' }
GtCoderNavigationPackagesTreeElement >> buildContent [ 
	| tree |
	tree := BrColumnedTree new.
	tree 
		items: (RPackageOrganizer default packages sort: [ :a :b | a name < b name ])
		children: [ :anObject | (anObject isKindOf: RPackage) 
			ifTrue: [ anObject definedClasses ] 
			ifFalse: [ #() ] ].
	tree column
		stencil: [ :anObject | BrColumnCellLabelStencil new 
			text: anObject value name asRopedText glamorousRegularFontAndSize ].
	tree when: BrSelectionChanged do: [ :anEvent |
		anEvent selectedDo: [ :anInterval | 
			tree selectedNodeDo: [  :aNode | 
				aNode value isClass ifTrue: [ 
					navigationModel selectInCoderClass: aNode value ] ] ] ].
	self addChild: tree
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initialize [ 
	super initialize.
	self 
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> navigationModel: aNavigationModel [
	navigationModel := aNavigationModel.
	self buildContent.
	navigationModel theClass ifNotNil: [ :aClass |
		self selectClass: aClass ].
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> packagesTree [
	^ self children first
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> selectClass: aClass [
	| classPackage | 
	classPackage := aClass package.
	self packagesTree viewModel root childrenNodes
		detect: [ :each | each value = classPackage ]
		ifFound: [ :aTreeNode |
			aTreeNode isExpanded ifFalse: [ aTreeNode expand ] ].
]
