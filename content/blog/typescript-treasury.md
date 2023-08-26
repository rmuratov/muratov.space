---
title: "TypeScript treasury"
date: 2023-08-26T18:50:00+04:00
description: TypeScript cookbook. TypeScript tips and tricks.
image: /images/preview.jpg
---

## Recursive types

**TL;DR**

```typescript
type RecursiveTypeNode<T> = Record<string, T | null>;
interface RecursieveType extends RecursiveTypeNode<RecursieveType> {}
```

I needed to create a type for a recursive structure like this:

```typescript
const template = {
  'Page 1': {
    'Page 1 1': {
      'Page 1 1 1': {
        'Page 1 1 1 1': null,
        'Page 1 1 1 2': null,
      },
      'Page 1 1 2': null,
    },
    'Page 1 2': null,
    'Page 1 3': null,
  },
  'Page 2': {
    'Page 2 1': null,
    'Page 2 2': null,
  },
  'Page 3': null,
};
```

This is a collection of pages; every page is either a collection of pages or null. My first thought was to simply write this:

```typescript
type RecursieveType = Record<string, RecursieveType | null>
```

Does not work, TypeScript says:  

```
TS2456: Type alias RecursieveType circularly references itself.
```

It turned out that type aliases can not be recursive, but interfaces can. See the solution above.
