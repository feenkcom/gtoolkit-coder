Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodCoder >> asCoderUIModel [
	^ GtPharoMethodCoderViewModel new coder: self
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodCoder >> breadcrumbActions [
	<return: #Array of: #GtSourceCoderBreadcrumbAction>
	^ Array
		streamContents: [ :aStream | 
			(self compiledMethod ifNil: [ self behavior ]) package
				ifNotNil: [ :aPackage | 
					aStream
						nextPut: (GtSourceCoderBreadcrumbSpawnPackageAction new package: aPackage) ].
			aStream nextPut: (GtSourceCoderBreadcrumbSpawnBehaviorAction new methodBehavior: self methodBehavior) ]
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodCoder >> browseFrom: anEditorElement [ 
	((GtCoder forMethod: self compiledMethod)
		openInPagerFrom: anEditorElement)
			maximized
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodCoder >> buildRemoveMethodLabel: anElement [
	| references element labelText |
	(self isNewMethod
		or: [ selector isNil
				or: [ (references := self selector gtReferences) isEmpty ] ])
		ifTrue: [ ^ BrLabel new
				margin: (BlInsets all: 10);
				look: BrGlamorousLabelLook new glamorousRegularFont;
				text: 'Remove method?' asRopedText ].
	labelText := selector asRopedText glamorousCodeFontAndSize bold.
	labelText
		append: ' is still referenced in ' asRopedText glamorousRegularFontAndSize.
	element := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	element
		addChild:
			(BrLabel new
				margin:
					(BlInsets
						top: 10
						left: 10
						bottom: 10
						right: 0);
				look: BrGlamorousLabelLook new;
				text: labelText).
	(labelText from: 1 to: selector size)
		attributes:
			{(BlFontFamilyAttribute named: 'Source Code Pro')
				beNotOverwritableByStyler}.
	element
		addChild:
			(BrButton new
				look: BrGlamorousLinkSquaredButtonWithLabelLook new;
				beSmallSize;
				margin: (BlInsets top: 10 left: 2 bottom: 10 right: 10);
				label:
					(references size printString , ' method'
						,
							(references size = 1
								ifTrue: [ '' ]
								ifFalse: [ 's' ])) asRopedText glamorousRegularFontAndSize;
				action: [ anElement phlow spawnObject: references ]).
	^ element
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodCoder >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtSourceCoderPlayShortcut new;
		addShortcut: GtSourceCoderPlayAndInspectShortcut new;
		addShortcut: GtSourceCoderExtractMethodShortcut new;
		addShortcut: GtSourceCoderSaveShortcut new;
		addShortcut: GtSourceCoderFormatShortcut new
]
