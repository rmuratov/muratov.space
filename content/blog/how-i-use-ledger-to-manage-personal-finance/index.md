---
title: "How I Use Ledger to Manage Personal Finance"
date: 2023-07-05T00:00:00+04:00
image: /images/calculator.jpg
---

[Ledger](https://ledger-cli.org/) is a double-entry plaintext accounting system. Plaintext means that you do your finance editing a simple text file and process it with a command line utility :) In this post, I share my approach to using Ledger. If you want to know more about plaintext accounting, visit https://plaintextaccounting.org/.

I only use Ledger for two months, so this is probably not final. This is not an introduction to the Ledger. I assume you are familiar with it.

## File structure and initial setup

I store all related files in a folder called `Bookkeeping`. Let's see what's inside:

```shell
$ cd Bookkeeping
$ ls -1
2023-05.ledger.txt
2023-06.ledger.txt
accounts.ledger.txt
commodities.ledger.txt
journal.ledger.txt
price-history.ledger.txt
```

### accounts.ledger.txt

In this file, I declare all my accounts. More about my approach to defining accounts later. Here is a sneak peek:

```json
; Assets
account Assets:Business
account Assets:Personal
account Assets:Cash

; Equity
account Equity:Conversion
account Equity:Opening Balances

; Expenses
account Expenses:Groceries
account Expenses:Fees
account Expenses:Subscriptions

; Income
account Income:Salary
```

### commodities.ledger.txt

Here I declare commodities. So far I only use currencies.

```json
commodity USD
    format 1.00 USD
commodity EUR
    format 1.00 EUR
commodity RUB
    format 1.00 RUB
commodity GEL
    format 1.00 GEL
```

### price-history.ledger.txt

In this file, I track prices of every other currency in USD. This way I can see my net worth in one single number. From time to time I update the data.

```json
P 2023-05-10 00:00:00 GEL 0.395 USD
P 2023-05-10 00:00:00 EUR 1.1 USD
P 2023-05-10 00:00:00 RUB 0.0131 USD

P 2023-06-01 00:00:00 GEL 0.38 USD
P 2023-06-01 00:00:00 EUR 1.07 USD
P 2023-06-01 00:00:00 RUB 0.012 USD
```

### accounts.ledger.txt

This is my actual journal. This file includes every other file and in this file I write my postings for _this_ month. Every month I copy-paste every posting from `accounts.ledger.txt` into separate file with month and year in its name and include it in `accounts.ledger.txt` (notice `2023-05.ledger.txt`) file. Here is the beginning of the main journal file:

```json
include accounts.ledger.txt
include commodities.ledger.txt
include price-history.ledger.txt

; Order is important here!
include 2023-05.ledger.txt
include 2023-06.ledger.txt

; Here go postings for this month
```

### VS Code and iCloud setup

Actually, I have one more file inside my `Bookkeeping` directory. It's called `ledger.code-workspace` and here is it's content:

```json
{
  "folders": [{ "path": "/Users/user/Documents/Bookkeeping" }]
}
```

This file is VS Code workspace. And when I click it VS Code opens my `Bookkeeping` directory with all the related ledger files and I can now edit them.

I use MacBook and store my `Bookkeeping` directory in `/Users/user/Library/Mobile Documents/com~apple~CloudDocs/`. That way it syncs via iCloud and I can edit my journal on my iPhone (`.ledger.txt` extension is exactly for this, either way, iPhone can not open files). Though I [do not do it](/blog/i-tried-being-productive-with-smartphones-but-i-love-computers-more) often.

Going to `/Users/user/Library/Mobile Documents/com~apple~CloudDocs/` every time I want to edit my journal is not that convenient. So I have a symlink to my `~/Documents` folder.

## How do I do actual journaling

My routine by no means is advanced. I do not use any automated tools to parse bank statements. I also use a very basic set of Ledger features, i.e. just regular expenses, no stock tracking. And I don’t use auto postings, because for me they make things implicit, which I don’t like.

Every morning I open my journal file and write down everything that happened the previous day. I check my expenses on the bank’s mobile apps. When I first tried keeping track of money 10 years ago, I thought it would be tedious to record every expense. But it turned out that in real life you do not make so many purchases. Every day I have no more than 5 minutes to keep a journal.

## Accounts structure

The fewer accounts the better. My top-level accounts are typical: `Assets`, `Expenses`, `Equity`, and `Income`.

The most diverse category is of course `Expenses`. I’d recommend not overcomplicating it and only extracting to separate account things that are important to you. For example, I have an account such as `Expenses:Alcohol` 😅. Anyway, It takes several weeks for the structure to take its final shape.

Some other accounts under `Expenses`: `Groceries`, `Subscriptions`, `Fees`, `Transport`, `Utilities`.

## Typical postings

Here is my top postings type.

### Regular expense

Almost all of my postings are cleared (\*). I wish this was by default, so I don't need to specify it every time. I also learned to always specify fractional part for consistency, even if it's zero. Regarding payee (e.g. Bolt) it's not very strict, I might omit it completely. I also don't use currencies symbols, because except `$` they are hard to type. VS Code automatically autocompletes my accounts while I type.

```json
2023-07-01 * Bolt
    Expenses:Transport:Taxi  5.10 GEL
    Assets:BOG:Personal
```

### Transfer

I always use `Equity:Conversion` so that transfers are balanced.

```json
2023-07-04 * Transfer
    Assets:BOG:Personal  257.50 GEL
    Equity:Conversion  -257.50 GEL
    Equity:Conversion  100.00 USD
    Assets:BOG:Personal  -100.00 USD
```

### Lending money

Just move assets to `Assets:Reimbursements:<Person>` account.

```json
2023-07-04 * John Doe
    Assets:Reimbursements:John  100.00 USD
    Assets:Bank
```

## Reporting

First of all, to not specify a journal file in every command I specify `LEDGER_FILE` environment variable in my `.zshrc`:

```shell
export LEDGER_FILE="/Users/user/Library/Mobile Documents/com~apple~CloudDocs/Bookkeeping/journal.ledger.txt"
```

To be honest, my most used command is not `ledger`'s command, but rather `hledger`'s command. Yep, `hledger` is another plaintext accounting program with an almost compatible journal format. I haven't yet decided which one to use exclusively so I use both.

Here is my top-used reports.

### How much money do I have?

I use this command right after I am done with writing postings for the previous day. Then I compare the output with what I see on the bank’s apps and fix errors if any.

```shell
$ hledger bs
Balance Sheet 2023-07-05

                         ||                                       2023-07-05 
=========================++==================================================
 Assets                  ||                                                  
-------------------------++--------------------------------------------------
 Assets:Business         ||                            12.92 GEL, 300.00 USD 
 Assets:Cool Bank        ||                                     50000.50 RUB 
 Assets:Personal         ||                           200.00 GEL, 350.00 USD 
 Assets:Personal:Deposit ||                  50.00 EUR, 50.00 GEL, 50.00 USD 
 Assets:Savings:Cash     ||                           200.00 EUR, 100.00 USD 
-------------------------++--------------------------------------------------
                         || 250.00 EUR, 262.92 GEL, 50000.50 RUB, 800.00 USD 
=========================++==================================================
 Liabilities             ||                                                  
-------------------------++--------------------------------------------------
-------------------------++--------------------------------------------------
                         ||                                                  
=========================++==================================================
 Net:                    || 250.00 EUR, 262.92 GEL, 50000.50 RUB, 800.00 USD
```

If I want to see my net worth in one single number, I convert everything to USD based on `price-history.ledger.txt`:

```shell
$ hledger -f wow.ledger bs -X USD
Balance Sheet 2023-07-05, valued at period ends

                         ||  2023-07-05
=========================++=============
 Assets                  ||
-------------------------++-------------
 Assets:Business         ||  304.91 USD
 Assets:Cool Bank        ||  600.01 USD
 Assets:Personal         ||  426.00 USD
 Assets:Personal:Deposit ||  122.50 USD
 Assets:Savings:Cash     ||  314.00 USD
-------------------------++-------------
                         || 1767.42 USD
=========================++=============
 Liabilities             ||
-------------------------++-------------
-------------------------++-------------
                         ||
=========================++=============
 Net:                    || 1767.42 USD
```

### How much money did I spend the last month?

This command shows only top-level categories under `Expenses`.

```shell
$ ledger -S T --depth 2 --no-pager --period 'last month' --group-by 'commodity' balance Expenses
GEL
         1105.00 GEL  Expenses
            5.00 GEL    Fees
          100.00 GEL    Transport
         1000.00 GEL    Groceries
--------------------
         1105.00 GEL

RUB
         2200.00 RUB  Expenses
         1000.00 RUB    Subscriptions
          200.00 RUB    Entertainment
         1000.00 RUB    Utilities
--------------------
         2200.00 RUB

USDs
          107.94 USD  Expenses
          100.00 USD    Rent
            5.98 USD    Subscriptions
            1.96 USD    Fees
--------------------
          107.94 USD
```

That's pretty much all I care about for now -- net worth and last month's expenses. 

### Checks

From time to time I run checks to be sure everything is correct. E.g. it will throw an error if there are postings with unspecified accounts. For reference see [docs](https://hledger.org/1.29/hledger.html#check).

```shell
$ hledger check --strict ordereddates
```

## Conclusion

I am only at the beginning of mastering the program, but already I am benefiting from its use. And I think it will only get better with time. The most important thing is that I have developed discipline and regularly keep my journal and even do it with pleasure, which I cannot say about other means, such as mobile applications.