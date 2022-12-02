Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtAddButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		icon: BrGlamorousVectorIcons add;
		tooltip: 'Add class or package';
		priority: 5;
		content: [ :aDropdown | 
			| element |
			element := BlElement new.
			element
				constraintsDo: [ :c | 
					c horizontal exact: 400.
					c vertical exact: 300 ].
			element addChild: (self gtAddInterface: aDropdown).
			element ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtAddClassTab: look [
	<gtCreateComponentTab: 10>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Class';
		stencil: [ | element navigationModel |
			element := GtPharoCreateBehaviorElement new.
			navigationModel := look phlow firstParentWithView navigationModel.
			element
				behaviorBlock: [ :cls | 
					look fireEvent: BrDropdownHideWish new.
					navigationModel selectClass: cls ].
			element forClassDefinition.
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtAddInterface: look [
	| contentTabs tabMethods |
	contentTabs := BrTabGroup new.
	contentTabs aptitude: BrGlamorousTabGroupAptitude new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabMethods := (Pragma allNamed: #gtCreateComponentTab: from: self class to: Behavior)
		asSortedCollection: [ :a :b | a arguments first < b arguments first ].
	tabMethods
		do:
			[ :each | contentTabs addTab: (self perform: each method selector with: look) ].
	^ contentTabs
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtAddPackageTab: look [
	<gtCreateComponentTab: 30>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Package';
		stencil: [ | element navigationModel |
			element := GtPharoCreatePackageElement new.
			navigationModel := look phlow firstParentWithView navigationModel.
			element
				packageBlock: [ :pkg :tag | 
					look fireEvent: BrDropdownHideWish new.
					tag isNil
						ifTrue: [ navigationModel selectPackage: pkg ]
						ifFalse: [ navigationModel selectPackageTag: tag ] ].
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			element ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtAddTraitTab: look [
	<gtCreateComponentTab: 20>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Trait';
		stencil: [ | element navigationModel |
			element := GtPharoCreateBehaviorElement new.
			navigationModel := look phlow firstParentWithView navigationModel.
			element
				behaviorBlock: [ :cls | 
					look fireEvent: BrDropdownHideWish new.
					navigationModel selectClass: cls ].
			element forTraitDefinition.
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Browse in another world tab';
		priority: 1;
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | self gtBrowseFromButton: aButton ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"
	anElement phlow firstParentWithView navigationModel coderDo: [ :aCoder | 
		((GtCoder forCoder: aCoder asNewCoderModelWithSameSubject)
			openInPagerFrom: anElement)
				maximized ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtHierarchyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		priority: 3;
		content: [ :aButton | 
			| coder |
			coder := aButton phlow firstParentWithView.
			BlElement new
				size: 400 @ 400;
				addChild: ((GtCoderNavigationTabsStencil new
						navigationModel: coder navigationModel;
						asElement) background: Color white) ]
]
