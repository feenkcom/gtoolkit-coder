Class {
	#name : #GtAbstractCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #accessing }
GtAbstractCoderContextMenuContent >> initialize [
	super initialize.
	self
		stencil: self menuItemStencil;
		padding: (BlInsets
				top: 8
				right: 10
				bottom: 8
				left: 10);
		hFitContent;
		vFitContent
]

{ #category : #accessing }
GtAbstractCoderContextMenuContent >> itemLabelFor: labelText [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: labelText;
		hMatchParent;
		yourself
]

{ #category : #accessing }
GtAbstractCoderContextMenuContent >> itemPadding [
	^ BlInsets top: 2 bottom: 2
]

{ #category : #accessing }
GtAbstractCoderContextMenuContent >> menuItemStencil [
	self subclassResponsibility
]

{ #category : #accessing }
GtAbstractCoderContextMenuContent >> selectionAptitude [
	^ BrStyleCommonAptitude new
		hovered: [ :aStyle | aStyle background: self theme item selectedColor ]
]
